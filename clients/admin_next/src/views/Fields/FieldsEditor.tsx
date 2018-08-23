import * as React from "react";
import * as Leaflet from "leaflet";
import { Map } from "react-leaflet";
import {createFragmentContainer, graphql} from "react-relay";
import FieldsEditorMap from "./FieldsEditorMap";
import FieldsEditorInputs from "./FieldsEditorInputs";
import FieldsEditorControls from "./FieldsEditorControls";
import FieldsEditorActions from "./FieldsEditorActions";
import { FieldStyle } from "./FieldStyle";
import UpdateMapMutation from "../../mutations/UpdateMap";
import UpdateFieldMutation from "../../mutations/UpdateField";
import CreateFieldMutation from "../../mutations/CreateField";
import { showNotice } from "../../components/Notice";
import quadrilateralise from "./quadrilateralise";
import { merge } from "lodash";

interface Props {
  map: FieldsEditor_map;
  fields: FieldsEditor_fields;
}

type Mode = "none" | "view" | "editMap" | "addField" | "editField";

interface State {
  mode: Mode;
  lat: number;
  long: number;
  zoom: number;
  submitting: boolean;
  editing: {
    fieldId?: string;
    name: string;
    lat: number;
    long: number;
    geoJson: string;
  };
  nameError?: string;
}

const newField = {
  name: "",
  lat: 0,
  long: 0,
  geoJson: ""
};

class FieldsEditor extends React.Component<Props, State> {
  mapRef = React.createRef<Map>();
  map?: Leaflet.Map;

  constructor(props: Props) {
    super(props);

    const { lat, long, zoom } = props.map;

    this.state = {
      mode: "view",
      lat,
      long,
      zoom,
      submitting: false,
      editing: newField
    };
  }

  componentDidMount() {
    this.map = this.mapRef.current!.leafletElement;
    this.map!.on("editable:drawing:commit", this.updateField);
    this.map!.on("editable:vertex:dragend", this.updateField);
    this.map!.on("editable:vertex:rawclick", this.noOp); // prevent vertex delete
  }

  /* Mode change handlers */
  editMap = () => {
    const { lat, long, zoom } = this.props.map;
    this.setState({mode: "editMap", lat, long, zoom});
  }

  addField = () => {
    this.map!.editTools.startPolygon();
    this.map!.on("contextmenu", this.startDrawingMobile);
    this.map!.on("editable:drawing:clicked", this.autoComplete);
    this.setState({mode: "addField", editing: newField});
  }

  editField = (field: FieldsEditor_fields[0], polygon: Leaflet.Polygon) => {
    this.resetEditing();
    polygon.enableEdit();
    this.setState({mode: "editField", editing: field});
  }

  resetEditing = () => {
    this.map!.eachLayer((layer: Leaflet.ILayer) => {
      const polygon = layer as Leaflet.Polygon;
      if (polygon.disableEdit) { polygon.disableEdit(); }
    });
  }

  /* Leaflet event handlers */
  startDrawingMobile = (event: Leaflet.LeafletMouseEvent) => {
    this.map!.editTools.startPolygon(event.latlng);
    this.map!.off("contextmenu", this.startDrawingMobile);
  }

  updateMap = () => {
    const {lat, lng: long} = this.map!.getCenter();
    const zoom = this.map!.getZoom();
    this.setState({lat, long, zoom});
  }

  updateField = (event: Leaflet.LeafletGeoJSONEvent) => {
    const polygon = event.layer as Leaflet.Polygon;

    const {lat, lng: long} = polygon.getBounds().getCenter();
    const geoJson = polygon.toGeoJSON();

    const editing = {...this.state.editing};
    merge(editing, {lat, long, geoJson: JSON.stringify(geoJson)});

    this.setState({editing});
  }

  squareFieldCorners = () => {
    const geoJson = JSON.parse(this.state.editing.geoJson);
    const orthGeoJson = quadrilateralise(geoJson, this.map!);
    const layer = this.editingLayer();

    this.replaceLayer(layer, orthGeoJson);
  }

  editingLayer = () => {
    const layers = new Leaflet.LayerGroup();

    this.map!.eachLayer((l) => {
      const p = l as Leaflet.Polygon;
      if (p.editEnabled && p.editEnabled()) {
        layers.addLayer(p);
      }
    });

    return layers;
  }

  replaceLayer = (layers: Leaflet.LayerGroup<Leaflet.ILayer>, geoJson: any) => {
    layers.eachLayer((l) => this.map!.removeLayer(l));

    const newLayers = Leaflet.geoJson(geoJson, {style: () => FieldStyle}).addTo(this.map!);

    newLayers.eachLayer((l) => {
      const p = l as Leaflet.Polygon;
      p.enableEdit();
    });
  }

  // https://github.com/Leaflet/Leaflet.Editable/blob/master/src/Leaflet.Editable.js#L389
  noOp = (event: {cancel: () => void}) => {
    event.cancel();
  }

  // getLatLngs returns [][]
  // https://github.com/DefinitelyTyped/DefinitelyTyped/issues/14809
  autoComplete = (event: any) => {
    const verticies = event.layer.getLatLngs()[0];

    if (verticies.length === 4) {
      event.editTools.commitDrawing(); // auto complete the polygon on the 4th vertex
      this.map!.off("editable:drawing:clicked", this.autoComplete); // cleanup
    }
  }

  /* Input event handlers */
  placeSelected = (lat: number, long: number) => {
    const defaultZoom = 15;
    this.setState({lat, long, zoom: defaultZoom});
  }

  updateName = (event: React.FormEvent<EventTarget>) => {
    const target = event.target as HTMLInputElement;

    const editing = {...this.state.editing};
    merge(editing, {name: target.value});

    this.setState({editing, nameError: undefined});
  }

  validate = () => {
    const namePresent = this.state.editing.name !== "";
    const geoJsonPresent = this.state.editing.geoJson !== "";
    return namePresent && geoJsonPresent;
  }

  /* Save actions */
  saveMap = () => {
    const { lat, long, zoom } = this.state;
    const payload = { lat, long, zoom };
    this.runMutation(UpdateMapMutation, payload);
  }

  createField = () => {
    const payload = this.state.editing;
    this.runMutation(CreateFieldMutation, payload);
  }

  saveField = () => {
    const payload = {id: this.state.editing.fieldId!, ...this.state.editing};
    this.runMutation(UpdateFieldMutation, payload);
  }

  /* Mutations */
  runMutation = async (mutation: any, payload: any) => {
    this.setState({submitting: true});

    try {
      const result = await mutation.commit({input: payload});
      result.success
        ? this.mutationSuccess(result)
        : this.mutationFailed(result);
    } catch (e) {
      this.setState({submitting: false});
      showNotice(e.message);
    }
  }

  mutationSuccess = (result: MutationResult) => {
    this.resetEditing();
    this.setState({mode: "none", submitting: false});
    showNotice(result.message!);
    setTimeout(() => this.setState({mode: "view"}), 1000);
  }

  mutationFailed = (result: MutationResult) => {
    const userErrors = result.userErrors || [];
    const userError = userErrors.filter((e) => e.field === "name")[0];
    const errorMessage = userError && userError.message || "";

    this.setState({nameError: errorMessage, submitting: false});
    showNotice(result.message!);
  }

  /* Rendering */
  render() {
    const { lat, long, zoom, submitting } = this.state;
    const { fields } = this.props;

    return (
      <FieldsEditorMap
        ref={this.mapRef}
        lat={lat}
        long={long}
        zoom={zoom}
        fields={fields}
        updateMap={this.updateMap}
        editField={this.editField}
      >
        <FieldsEditorInputs
          mode={this.state.mode}
          placeSelected={this.placeSelected}
          name={this.state.editing.name}
          updateName={this.updateName}
          nameError={this.state.nameError}
        />
        <FieldsEditorControls
          mode={this.state.mode}
          geojson={this.state.editing.geoJson}
          squareFieldCorners={this.squareFieldCorners}
        />
        <FieldsEditorActions
          mode={this.state.mode}
          valid={this.validate()}
          submitting={submitting}
          editMap={this.editMap}
          addField={this.addField}
          saveMap={this.saveMap}
          createField={this.createField}
          saveField={this.saveField}
        />
      </FieldsEditorMap>
    );
  }
}

export default createFragmentContainer(FieldsEditor, {
  map: graphql`
    fragment FieldsEditor_map on Map {
      lat
      long
      zoom
    }
  `,
  fields: graphql`
    fragment FieldsEditor_fields on Field @relay(plural: true) {
      id
      name
      lat
      long
      geoJson
    }
  `
});
