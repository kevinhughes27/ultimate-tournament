var React = require('react'),
    Griddle = require('griddle-react'),
    FilterBar = require('./filter_bar'),
    FilterBarMixin = require('../lib/filter_bar_mixin'),
    NameCell = require('./game').NameCell,
    ScoreCell = require('./game').ScoreCell,
    ConfirmedCell = require('./game').ConfirmedCell,
    GamesStore = require('../stores/games_store');

var columns = [
  "name",
  "division",
  "score",
  "confirmed"
];

var searchColumns = [
  "name",
  "division"
];

var filterColumns = [
  "division",
  "confirmed"
];

var columnsMeta = [
  {
    columnName: "name",
    displayName: "Game",
    cssClassName: "col-md-7 table-link",
    order: 1,
    customComponent: NameCell
  },
  {
    columnName: "division",
    displayName: "Division",
    cssClassName: "col-md-2 table-link",
    order: 2,
  },
  {
    columnName: "score",
    displayName: "Score",
    cssClassName: "col-md-1 table-link",
    order: 3,
    sortable: false,
    customComponent: ScoreCell
  },
  {
    columnName: "confirmed",
    displayName: "Confirmed",
    cssClassName: "col-md-2 table-link",
    order: 4,
    customComponent: ConfirmedCell
  },
];

var rowMetadata = {
  bodyCssClassName: function(rowData) {
    var game = rowData;
    var sotgWarning = _.some(game.score_reports, function(report){ return report.sotg_warning });

    if(sotgWarning) {
      return 'warning';
    }

    return 'default-row';
  }
};

class GamesFilter extends FilterBar {
  filterColumns() { return filterColumns; }
}

var GamesIndex = React.createClass({
  mixins: [FilterBarMixin],

  searchColumns() { return searchColumns; },

  getInitialState() {
    GamesStore.init(this.props.games);

    return {
      games: GamesStore.all(),
    };
  },

  componentDidMount() {
    GamesStore.addChangeListener(this._onChange);
  },

  componentWillUnmount() {
    GamesStore.removeChangeListener(this._onChange);
  },

  _onChange() {
    this.setState({ games: GamesStore.all() });
  },

  render() {
    var games = this.state.games;

    return (
      <Griddle
        results={games}
        tableClassName="table table-striped table-hover"
        columns={columns}
        columnMetadata={columnsMeta}
        rowMetadata={rowMetadata}
        resultsPerPage={games.length}
        showPager={false}
        useGriddleStyles={false}
        sortAscendingClassName="sort asc"
        sortAscendingComponent=""
        sortDescendingClassName="sort desc"
        sortDescendingComponent=""
        showFilter={true}
        useCustomFilterer={true}
        customFilterer={this.filterFunction}
        useCustomFilterComponent={true}
        customFilterComponent={GamesFilter}
      />
    );
  }
});

module.exports = GamesIndex;
