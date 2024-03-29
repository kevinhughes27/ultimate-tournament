import React, { Component } from 'react';
import { connect } from 'react-redux';
import queryString from 'query-string';

import AppBar from '@material-ui/core/AppBar';
import Toolbar from '@material-ui/core/Toolbar';
import IconButton from '@material-ui/core/IconButton';
import SearchIcon from '@material-ui/icons/Search';
import AutoComplete from './AutoComplete';

class TopBar extends Component {
  componentDidMount() {
    teamDeepLink(this.props.params, this.props.dispatch);
  }

  render() {
    const { teams, search, dispatch } = this.props;
    const teamNames = teams.map(t => t.name);

    return (
      <AppBar>
        <Toolbar>
          <IconButton color="inherit">
            <SearchIcon />
          </IconButton>
          <AutoComplete
            value={search}
            placeholder="Search Teams"
            suggestions={teamNames}
            onChange={search => {
              dispatch({ type: 'SET_SEARCH', value: search });
            }}
          />
        </Toolbar>
      </AppBar>
    );
  }
}

function teamDeepLink(params, dispatch) {
  const teamName = queryString.parse(params)['teamName'];

  if (teamName) {
    dispatch({ type: 'SET_SEARCH', value: teamName });
  }
}

export default connect(state => ({
  params: state.router.location.search,
  search: state.search,
  teams: state.tournament.teams
}))(TopBar);
