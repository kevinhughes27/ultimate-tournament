class Types::Team < Types::BaseObject
  graphql_name "Team"
  description "A Team"

  field :id, ID, null: false
  field :name, String, null: false
  field :email, String, auth: :required, null: true
  field :phone, String, auth: :required, null: true
  field :division, Types::Division, null: true
  field :seed, Int, null: true

  def seed
    AssociationLoader.for(::Team, :seed).load(object).then do |seed|
      seed && seed.rank
    end
  end

  def division
    AssociationLoader.for(::Team, :seed).load(object).then do |seed|
      RecordLoader.for(::Division).load(seed.division_id) if seed
    end
  end
end
