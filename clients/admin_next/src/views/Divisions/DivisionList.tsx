import * as React from "react";
import { withRouter, RouteComponentProps } from "react-router-dom";
import {createFragmentContainer, graphql} from "react-relay";

import Table from "@material-ui/core/Table";
import TableBody from "@material-ui/core/TableBody";
import TableCell from "@material-ui/core/TableCell";
import TableHead from "@material-ui/core/TableHead";
import TableRow from "@material-ui/core/TableRow";

import Breadcrumbs from "../../components/Breadcrumbs";
import DivisionListItem from "./DivisionListItem";
import ActionButton from "../../components/ActionButton";

interface Props extends RouteComponentProps<{}> {
  divisions: DivisionList_divisions;
}

class DivisionList extends React.Component<Props> {
  render() {
    const { divisions } = this.props;

    return (
      <div>
        <Breadcrumbs items={[{text: "Divisions"}]} />
        <Table>
          <TableHead>
            <TableRow>
              <TableCell>Name</TableCell>
              <TableCell>Bracket</TableCell>
              <TableCell>Teams</TableCell>
              <TableCell>Seeded</TableCell>
            </TableRow>
          </TableHead>
          <TableBody>
            {divisions.map((d) => <DivisionListItem key={d.id} division={d as DivisionListItem_division}/>)}
          </TableBody>
        </Table>
        <ActionButton onClick={() => this.props.history.push("/divisions/new")}/>
      </div>
    );
  }
}

export default createFragmentContainer(withRouter(DivisionList), {
  divisions: graphql`
    fragment DivisionList_divisions on Division @relay(plural: true) {
      id
      ...DivisionListItem_division
    }
  `
});
