import React, { Component } from 'react';
import { connect } from 'react-redux';
import List from '@material-ui/core/List';
import ListItem from '@material-ui/core/ListItem';
import ListSubheader from '@material-ui/core/ListSubheader';
import Lock from './Lock';
import SubmitModal from './SubmitModal';
import gamesSearch from '../../helpers/gamesSearch';
import findTeam from '../../helpers/findTeam';

class SubmitView extends Component {
  render() {
    const { search, teams, games, reports } = this.props;

    if (this.props.protect) {
      return (
        <Lock>
          {renderContent(search, teams, games, reports)}
        </Lock>
      );
    } else {
      return renderContent(search, teams, games, reports);
    }
  }
}

function renderContent(search, teams, games, reports) {
  const filteredGames = gamesSearch(search, games);

  if (search === '') {
    return <div className="center">Please search for your team</div>;
  } else if (filteredGames.length === 0) {
    return (
      <div className="center">
        No games found for team '{search}'
      </div>
    );
  } else {
    return renderGames(search, teams, filteredGames, reports);
  }
}

function renderGames(search, teams, games, reports) {
  const teamName = search;
  const team = findTeam(teams, teamName);

  return (
    <div>
      <List>
        <ListSubheader>Submit a score for each game played</ListSubheader>
        {games.map(game => renderGame(team, game, reports))}
      </List>
      <div style={{ paddingBottom: 56 }} />
    </div>
  );
}

function renderGame(team, game, reports) {
  const filteredReports = reports.filter(r => r.gameId === game.id);
  const report = filteredReports[filteredReports.length - 1];

  return (
    <ListItem key={game.id}>
      <SubmitModal team={team} game={game} report={report} />
    </ListItem>
  );
}

export default connect(state => ({
  protect: state.tournament.settings.protectScoreSubmit,
  teams: state.tournament.teams,
  games: state.tournament.games,
  reports: state.reports,
  search: state.search
}))(SubmitView);
