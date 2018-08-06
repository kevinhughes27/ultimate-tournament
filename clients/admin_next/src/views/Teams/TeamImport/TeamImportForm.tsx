import * as React from "react";
import { Formik, FormikValues, FormikProps, FormikActions } from "formik";
import FileInput from "../../../components/FileInput";
import csv from "csv";
import { isEqual } from "lodash";
import Button from "@material-ui/core/Button";
import ImportIcon from "@material-ui/icons/GroupAdd";

interface Props {
  startImport: (data: string[][]) => void;
}

interface State {
  data: string[][];
  error: string;
}

const defaultState =  {
  data: [],
  error: ""
};

class TeamImportForm extends React.Component<Props, State> {
  state = defaultState;

  initialValues = () => {
    return {
      csvFile: ""
    };
  }

  fileChanged = async (ev: React.ChangeEvent<HTMLInputElement>) => {
    this.setState(defaultState);

    const files = ev.target.files;

    if (files && files.length === 1) {
      const file = files[0];
      const csvData = await this.uploadCSV(file);
      this.validateCSV(csvData);
    }
  }

  uploadCSV = (file: File) => {
    const reader = new FileReader();

    return new Promise<string>((resolve) => {
      reader.onload = () => {
        resolve(reader.result);
      };

      reader.readAsText(file);
    });
  }

  validateCSV = (csvData: string) => {
    csv.parse(csvData, (err: string, data: string[][]) => {
      if (err) {
        this.setState({error: "Invalid CSV file"});
        return;
      }

      const header = data[0];
      const expectedHeader = ["Name", "Email", "Division", "Seed"];

      if (!isEqual(header, expectedHeader)) {
        this.setState({error: "Invalid CSV Columns"});
        return;
      }

      this.setState({data: data.slice(1)});
    });
  }

  onSubmit = ({}: FormikValues, actions: FormikActions<FormikValues>) => {
    actions.resetForm();
    this.props.startImport(this.state.data);
  }

  render() {
    return (
      <Formik
        initialValues={this.initialValues()}
        onSubmit={this.onSubmit}
        render={this.renderForm}
      />
    );
  }

  renderForm = (formProps: FormikProps<FormikValues>) => {
    const {
      values,
      handleChange,
      handleSubmit,
      isSubmitting,
    } = formProps;

    return (
      <form onSubmit={handleSubmit}>
        <FileInput
          name="csvFile"
          value={values.csvFile}
          accept=".csv"
          buttonText="CSV File"
          onChange={(ev) => {
            handleChange(ev);
            this.fileChanged(ev);
          }}
        />
        <p>{this.state.error}</p>
        <p>
          Download a sample CSV template to see an example of the required format.
        </p>

        <Button
          variant="contained"
          color="primary"
          type="submit"
          style={{marginTop: 20, float: "right"}}
          disabled={!this.state.data || isSubmitting}
        >
          <ImportIcon />
        </Button>
      </form>
    );
  }
}

export default TeamImportForm;
