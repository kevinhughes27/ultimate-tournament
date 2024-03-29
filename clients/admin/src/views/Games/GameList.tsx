import * as React from 'react';
import subscription from './subscription';

import AppBar from '@material-ui/core/AppBar';
import Badge from '@material-ui/core/Badge';
import Tabs from '@material-ui/core/Tabs';
import Tab from '@material-ui/core/Tab';

import Table from '@material-ui/core/Table';
import TableBody from '@material-ui/core/TableBody';
import TableCell from '@material-ui/core/TableCell';
import TableHead from '@material-ui/core/TableHead';
import TableRow from '@material-ui/core/TableRow';
import GameListItem from './GameListItem';
import BlankSlate from '../../components/BlankSlate';

import ActionMenu from '../../components/ActionMenu';
import DownloadIcon from '@material-ui/icons/CloudDownload';

interface Props {
  games: GameListQuery['games'];
  subscribeToMore: any;
}

class GameList extends React.Component<Props> {
  state = {
    tab: 0
  };

  componentDidMount() {
    this.props.subscribeToMore(subscription);
  }

  handleTab = (_event: any, tab: number) => {
    this.setState({ tab });
  };

  exportReports = () => {
    const url = '/score_reports.csv';
    window.location.href = url;
  };

  renderContent = () => {
    const tab = this.state.tab;
    const games = this.props.games;

    const currentGames = games.filter(g => {
      const started = g.startTime && new Date(g.startTime) < new Date();
      const finished = g.endTime && new Date(g.endTime) < new Date();
      return started && !finished;
    });

    const missingScores = games.filter(g => {
      const finished = g.endTime && new Date(g.endTime) < new Date();
      return (finished && !g.scoreConfirmed) || g.scoreDisputed;
    });

    const upcomingGames = games.filter(g => {
      const future = g.startTime && new Date(g.startTime) > new Date();
      return future;
    });

    const finishedGames = games.filter(g => {
      return g.scoreConfirmed;
    });

    if (games.length > 0) {
      return (
        <div style={{ maxWidth: '100%' }}>
          <AppBar position="static" color="default" style={{ paddingTop: 5 }}>
            <Tabs
              value={tab}
              onChange={this.handleTab}
              variant="scrollable"
              scrollButtons="on"
            >
              {this.renderTab('All', games.length, 'secondary')}
              {this.renderTab('On Now', currentGames.length, 'secondary')}
              {this.renderTab('Need Scores', missingScores.length, 'error')}
              {this.renderTab('Upcoming', upcomingGames.length, 'secondary')}
              {this.renderTab('Finished', finishedGames.length, 'primary')}
            </Tabs>
          </AppBar>
          {tab === 0 && this.renderList(games, 'No Games')}
          {tab === 1 && this.renderList(currentGames, 'No Games happening now')}
          {tab === 2 &&
            this.renderList(missingScores, 'No Games missing scores')}
          {tab === 3 && this.renderList(upcomingGames, 'No Games coming up')}
          {tab === 4 && this.renderList(finishedGames, 'No Games finished')}
          {this.renderActions()}
        </div>
      );
    } else {
      return (
        <BlankSlate>
          <h3>Games and Score Reports</h3>
          <p>
            After Divisions are created your games will be found here. Review
            and accept submitted scores from this page.
          </p>
        </BlankSlate>
      );
    }
  };

  renderTab = (
    name: string,
    count: number,
    color: 'primary' | 'secondary' | 'error' | 'default'
  ) => (
    <Tab
      label={
        <Badge
          badgeContent={count}
          color={color}
          style={{ paddingTop: 0, paddingRight: 15 }}
        >
          {name}
        </Badge>
      }
    />
  );

  renderList = (games: GameListQuery['games'], blankCopy: string) => {
    if (games.length > 0) {
      return (
        <div style={{ maxWidth: '100%', overflowX: 'scroll' }}>
          <Table>
            <TableHead>
              <TableRow>
                <TableCell>Name</TableCell>
                <TableCell>Division</TableCell>
                <TableCell>Pool</TableCell>
                <TableCell>Bracket</TableCell>
                <TableCell>Score</TableCell>
              </TableRow>
            </TableHead>
            <TableBody>
              {games.map(g => (
                <GameListItem key={g.id} game={g} />
              ))}
            </TableBody>
          </Table>
        </div>
      );
    } else {
      return (
        <BlankSlate>
          <p>{blankCopy}</p>
        </BlankSlate>
      );
    }
  };

  renderActions = () => {
    const actions = [
      {
        icon: <DownloadIcon />,
        name: 'Export Fields',
        handler: this.exportReports
      }
    ];

    return <ActionMenu actions={actions} />;
  };

  render() {
    return this.renderContent();
  }
}

export default GameList;
