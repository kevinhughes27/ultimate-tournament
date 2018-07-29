import * as React from "react";
import { withRouter, RouteComponentProps } from "react-router-dom";
import {createFragmentContainer, graphql} from "react-relay";
import { Map, TileLayer, GeoJSON } from "react-leaflet";
import { FieldStyle, FieldHoverStyle } from "./FieldStyle";
import Breadcrumbs from "../../components/Breadcrumbs";

interface Props extends RouteComponentProps<any> {
  map: FieldMap_map;
  fields: FieldMap_fields;
}

interface State {
  lat: number;
  long: number;
  zoom: number;
  hover?: string;
}

class FieldMap extends React.Component<Props, State> {
  constructor(props: Props) {
    super(props);
    const { lat, long, zoom } = props.map;
    this.state = {lat, long, zoom};
  }

  updateMap = (ev: any) => {
    const {lat, lng: long} = ev.target.getCenter();
    const zoom = ev.target.getZoom();
    this.setState({lat, long, zoom});
  }

  render() {
    const { lat, long, zoom } = this.state;
    const { fields } = this.props;

    return (
      <div>
        <Breadcrumbs items={[{text: "Fields"}]} />
        <Map
          center={[lat, long]}
          zoom={zoom}
          maxZoom={20}
          onDrag={this.updateMap}
          onZoom={this.updateMap}
        >
          <TileLayer
            url="https://{s}.google.com/vt/lyrs=s&x={x}&y={y}&z={z}"
            subdomains={["mt0", "mt1", "mt2", "mt3"]}
          />
          {fields.map(this.renderField)}
        </Map>
      </div>
    );
  }

  renderField = (field: FieldMap_fields[0]) => (
    <GeoJSON
      key={field.id}
      data={JSON.parse(field.geoJson)}
      style={this.fieldStyle(field.id)}
      onMouseover={() => this.setState({hover: field.id})}
      onMouseout={() => this.setState({hover: undefined})}
      onClick={() => this.handleClick(field.id)}
    />
  )

  handleClick = (fieldId: string) => {
    this.props.history.push(`/fields/${fieldId}`);
  }

  fieldStyle = (fieldId: string) => {
    if (this.state.hover === fieldId) {
      return FieldHoverStyle;
    } else {
      return FieldStyle;
    }
  }
}

export default createFragmentContainer(withRouter(FieldMap), {
  map: graphql`
    fragment FieldMap_map on Map {
      lat
      long
      zoom
    }
  `,
  fields: graphql`
    fragment FieldMap_fields on Field @relay(plural: true) {
      id
      name
      lat
      long
      geoJson
    }
  `
});
