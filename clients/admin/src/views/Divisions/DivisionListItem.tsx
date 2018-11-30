import * as React from "react";
import { withRouter, RouteComponentProps } from "react-router-dom";
import {createFragmentContainer, graphql} from "react-relay";
import TableCell from "@material-ui/core/TableCell";
import TableRow from "@material-ui/core/TableRow";
import TeamsCell from "./TeamsCell";
import SeededCell from "./SeededCell";
import { decodeId } from "../../helpers/relay";

interface Props extends RouteComponentProps<any> {
  division: DivisionListItem_division;
}

class DivisionListItem extends React.Component<Props> {
  handleClick = () => {
    const divisionId = decodeId(this.props.division.id);
    this.props.history.push(`/divisions/${divisionId}`);
  }

  render() {
    const { division } = this.props;

    return (
      <TableRow hover onClick={this.handleClick}>
      <TableCell>{division.name}</TableCell>
      <TableCell>{division.bracket.handle}</TableCell>
      <TableCell>{TeamsCell(division)}</TableCell>
      <TableCell>{SeededCell(division)}</TableCell>
    </TableRow>
    );
  }
}

export default createFragmentContainer(withRouter(DivisionListItem), {
  division: graphql`
    fragment DivisionListItem_division on Division {
      id
      name
      bracket {
        handle
      }
      teamsCount
      numTeams
      isSeeded
    }
  `
});
