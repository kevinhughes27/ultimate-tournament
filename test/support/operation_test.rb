require 'test_helper'

class OperationTest < ActiveSupport::TestCase
  setup do
    @user = FactoryGirl.create(:user)
    @tournament = FactoryGirl.create(:tournament)
    FactoryGirl.create(:tournament_user, user: @user, tournament: @tournament)
  end

  def execute_graphql(mutation, input_type, input)
    query_string = "mutation #{mutation}($input: #{input_type}!) {#{mutation}(input: $input) { success, userErrors }}"
    query_variables = {"input" => input.stringify_keys}

    result = Schema.execute(
      query_string,
      variables: query_variables,
      context: {
        tournament: @tournament,
        current_user: @user
      }
    )

    assert_nil result['errors'], 'GraphQL Errors'
    assert result['data'][mutation]['success'], "Mutation failed: #{result['data'][mutation]['userErrors']}"
  end
end