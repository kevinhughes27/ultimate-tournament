class Mutations::UnscheduleGame < Mutations::BaseMutation
  graphql_name "UnscheduleGame"

  argument :gameId, ID, required: true

  field :game, Types::Game, null: false
  field :success, Boolean, null: false
  field :message, String, null: true
  field :userErrors, [Types::Error], null: true
end