class Types::Team < Types::BaseObject
  graphql_name "Team"
  description "A Team"

  global_id_field :id

  field :name, String, null: false
  field :email, String, auth: :required, null: true
  field :phone, String, auth: :required, null: true
  field :division, Types::Division, null: true
  field :seed, Int, null: true
end
