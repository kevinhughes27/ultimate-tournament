class Mutations::DeleteField < Mutations::BaseMutation
  graphql_name "DeleteField"

  argument :input, Inputs::DeleteFieldInput, required: true

  field :success, Boolean, null: false
  field :confirm, Boolean, null: true
  field :userErrors, [String], null: true
end
