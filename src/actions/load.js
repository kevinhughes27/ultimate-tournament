import ApolloClient from 'apollo-client';
import gql from 'graphql-tag';

const client = new ApolloClient();

const query = gql`
  query {
    settings {
      protectScoreSubmit
    }
    map {
      lat
      long
      zoom
    }
    games(scheduled: true, hasTeam: true) {
      id
      homeName
      awayName
      startTime
      endTime
      fieldName
      homeScore
      awayScore
      scoreConfirmed
    }
    fields {
      id
      name
      lat
      long
      geoJson
    }
    teams {
      id
      name
    }
  }
`;

function loadApp() {
  return dispatch =>
    client
      .query({ query: query })
      .then(response =>
        dispatch({ type: 'LOAD_COMPLETED', response: response })
      )
      .catch(error => dispatch({ type: 'LOAD__FAILED', error }));
}

export { loadApp };
