import gql from 'graphql-tag';

export const query = gql`
  query TeamShowQuery($teamId: ID!) {
    team(id: $teamId) {
      id
      name
      email
    }
  }
`;
