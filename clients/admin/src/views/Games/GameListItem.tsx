import * as React from 'react';
import TableCell from '@material-ui/core/TableCell';
import TableRow from '@material-ui/core/TableRow';
import Modal from '../../components/Modal';
import ScoreForm from './ScoreForm';
import ScoreReport from './ScoreReport';
import ReportsBadge from './ReportsBadge';

interface Props {
  game: GameListQuery_games;
}

class GameListItem extends React.Component<Props> {
  state = {
    open: false
  };

  componentWillUnmount() {
    this.setState({ open: false });
  }

  handleClick = () => {
    if (!this.state.open) {
      this.setState({ open: true });
    }
  };

  handleClose = () => {
    if (this.state.open) {
      this.setState({ open: false });
    }
  };

  render() {
    const { game } = this.props;
    const gameName = `${game.homeName} vs ${game.awayName}`;

    return (
      <TableRow hover onClick={this.handleClick}>
        <TableCell>{gameName}</TableCell>
        <TableCell>{game.division.name}</TableCell>
        <TableCell>{game.pool}</TableCell>
        <TableCell>{game.bracketUid}</TableCell>
        {this.renderScoreCell()}
        {this.renderModal()}
      </TableRow>
    );
  }

  renderScoreCell = () => {
    const { game } = this.props;
    const reportCount = (game.scoreReports || []).length;

    if (game.homeScore && game.awayScore) {
      return (
        <TableCell>
          <ReportsBadge count={reportCount} disputed={game.scoreDisputed}>
            {game.homeScore} - {game.awayScore}
          </ReportsBadge>
        </TableCell>
      );
    } else {
      return <TableCell />;
    }
  };

  renderModal = () => {
    const { game } = this.props;
    const gameName = `${game.homeName} vs ${game.awayName}`;

    const input = {
      gameId: game.id,
      homeScore: game.homeScore || 0,
      awayScore: game.awayScore || 0
    };

    if (game.hasTeams) {
      return (
        <Modal
          open={this.state.open}
          onClose={this.handleClose}
          title={gameName}
        >
          <ScoreForm input={input} game={game} cancel={this.handleClose} />
          <div style={{ paddingBottom: 24 }}>
            {game.scoreReports!.map(r => (
              <ScoreReport key={r.id} report={r} />
            ))}
          </div>
        </Modal>
      );
    } else {
      return null;
    }
  };
}

export default GameListItem;
