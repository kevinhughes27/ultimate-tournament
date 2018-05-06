module Mutations
  SettingsUpdate = GraphQL::Relay::Mutation.define do
    name "SettingsUpdate"

    input_field :name, types.String
    input_field :handle, types.String
    input_field :score_submit_pin, types.Int
    input_field :game_confirm_setting, types.String
    input_field :timezone, types.String
    input_field :confirm, types.Boolean

    return_field :success, !types.Boolean
    return_field :confirm, types.Boolean
    return_field :errors, types[types.String]

    resolve(Auth.protect(Resolvers::SettingsUpdate))
  end
end
