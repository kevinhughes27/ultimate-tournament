import { ApolloClient } from 'apollo-client';
import { ApolloLink } from 'apollo-link';
import { HttpLink } from 'apollo-link-http';
import { setContext } from 'apollo-link-context';
import { InMemoryCache } from 'apollo-cache-inmemory';
import { getMainDefinition } from 'apollo-utilities';
import apolloLogger from 'apollo-link-logger';
import ActionCable from 'actioncable';
import ActionCableLink from 'graphql-ruby-client/subscriptions/ActionCableLink';
import auth from './auth';

const cable = ActionCable.createConsumer('/subscriptions');

const cableLink = new ActionCableLink({ cable });

const hasSubscriptionOperation = ({ query }: any) => {
  const definition = getMainDefinition(query);
  return (
    definition.kind === 'OperationDefinition' &&
    definition.operation === 'subscription'
  );
};

const httpLink = new HttpLink({
  uri: '/graphql'
});

const authLink = setContext((_, { headers }) => {
  const token = auth.getToken();

  return {
    headers: {
      ...headers,
      authorization: token ? `Bearer ${token}` : ''
    }
  };
});

const apiLink = authLink.concat(apolloLogger).concat(httpLink);

const link = ApolloLink.split(hasSubscriptionOperation, cableLink, apiLink);

const cache = new InMemoryCache();

const client = new ApolloClient({ link, cache });

export default client;
