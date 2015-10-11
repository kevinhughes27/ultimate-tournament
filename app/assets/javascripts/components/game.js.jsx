var _ = require('underscore'),
    React = require('react'),
    Collapse = require('react-bootstrap').Collapse,
    Popover = require('react-bootstrap').Popover,
    OverlayTrigger = require('react-bootstrap').OverlayTrigger,
    classNames = require('classnames'),
    ScoreReports = require('./score_reports');

var Game = React.createClass({
  getInitialState() {
    return {
      reportsOpen: false,
    };
  },

  _getGame() {
    var gameIdx = this.props.gameIdx;
    var games = this.props.gamesIndex.state.games;
    return games[gameIdx];
  },

  _toggleCollapse(e) {
    e.nativeEvent.preventDefault();
    this.setState({ reportsOpen: !this.state.reportsOpen });
  },

  render() {
    var game = this._getGame();
    var reportsOpen = this.state.reportsOpen;

    var nameRow;
    if (game.score_reports.length > 0) {
      nameRow = <div>
        <a href="#" onClick={this._toggleCollapse}>
          {game.name + " "}
          <span className="badge">{game.score_reports.length}</span>
        </a>
        <Collapse in={this.state.reportsOpen}>
          <div>
            <ScoreReports reports={game.score_reports} gamesIndex={this.props.gamesIndex}/>
          </div>
        </Collapse>
      </div>
    } else {
      nameRow = game.name;
    };

    var scoreForm = <Popover title={game.name}>
      <ScoreForm gameId={game.id}
                 homeScore={game.home_score}
                 awayScore={game.away_score}
                 gamesIndex={this.props.gamesIndex} />
    </Popover>;

    var confirmRow;
    if(game.confirmed) {
      confirmRow = <i className="fa fa-check" style={{color: 'green'}}></i>;
    } else if(game.played) {
      confirmRow = <i className="fa fa-exclamation-circle" style={{color: 'orange'}}></i>;
    } else {
      confirmRow = <i className="fa fa-question-circle" style={{color: '#008B8B'}}></i>;
    };

    var sotgWarning = _.some(game.score_reports, function(report){ return report.sotg_warning });

    return (
      <tr className={ classNames({warning: sotgWarning}) }>
        <td className="col-md-7 table-link">
          {nameRow}
        </td>
        <td className="col-md-2">
          {game.division}
        </td>
        <td className="col-md-1 table-link">
          <OverlayTrigger trigger="click" overlay={scoreForm}>
            <a href="#">{game.score}</a>
          </OverlayTrigger>
        </td>
        <td className="col-md-2">
          {confirmRow}
        </td>
      </tr>
    );
  }
});

var ScoreForm = React.createClass({
  getInitialState() {
    return {
      isLoading: false,
      homeScore: this.props.homeScore,
      awayScore: this.props.awayScore
    };
  },

  _startLoading() {
    Turbolinks.ProgressBar.start()
    this.setState({isLoading: true});
  },

  _finishLoading() {
    Turbolinks.ProgressBar.done()
    this.setState({isLoading: false});
  },

  updateScore() {
    this._startLoading();

    $.ajax({
      url: 'games/' + this.props.gameId + '.json',
      type: 'PUT',
      beforeSend: function(xhr) {xhr.setRequestHeader('X-CSRF-Token', $('meta[name="csrf-token"]').attr('content'))},
      data: {
        home_score: this.state.homeScore,
        away_score: this.state.awayScore
      },
      success: this.updateFinished
    })
  },

  updateFinished(response) {
    this._finishLoading();
    this.props.gamesIndex.updateGame(response.game);
  },

  render() {
    var btnClasses = classNames('btn', 'btn-default', {'is-loading': this.state.isLoading});

    return (
      <form className="form-inline">
        <input type="number"
               value={this.state.homeScore}
               className="form-control score-input"
               onChange={ (e) => {
                 this.setState({homeScore: e.target.valueAsNumber})
               }}/>
        <span> &mdash; </span>
        <input type="number"
               value={this.state.awayScore}
               className="form-control score-input"
               onChange={ (e) => {
                 this.setState({awayScore: e.target.valueAsNumber})
               }}/>
        <button className={btnClasses} onClick={this.updateScore}>
          Save
        </button>
      </form>
    );
  }
});

module.exports = Game;
