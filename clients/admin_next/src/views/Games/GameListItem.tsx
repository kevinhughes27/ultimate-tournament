import * as React from "react";
import { withRouter, RouteComponentProps } from "react-router-dom";
import {createFragmentContainer, graphql} from "react-relay";

import TableCell from "@material-ui/core/TableCell";
import TableRow from "@material-ui/core/TableRow";

interface Props extends RouteComponentProps<any> {
  game: Game;
}

class GameListItem extends React.Component<Props> {
  handleClick = () => {
    this.props.history.push(`/games/${this.props.game.id}`);
  }

  render() {
    const { game } = this.props;

    return (
      <TableRow hover onClick={this.handleClick}>
        <TableCell>{game.homeName} vs {game.awayName}</TableCell>
        <TableCell>{game.division.name}</TableCell>
        <TableCell>{game.pool}</TableCell>
        <TableCell>{game.homeScore} - {game.awayScore}</TableCell>
      </TableRow>
    );
  }
}

export default createFragmentContainer(withRouter(GameListItem), {
  game: graphql`
    fragment GameListItem_game on Game {
      id
      pool
      homeName
      awayName
      homeScore
      awayScore
      division {
        id
        name
      }
    }
  `
});