class Types::Query < Types::BaseObject
  field :viewer, Types::User, null: true

  def viewer
    context[:current_user]
  end

  field :settings, Types::Settings, null: false

  def settings
    context[:tournament]
  end

  field :map, Types::Map, null: false

  def map
    context[:tournament].map
  end

  field :fields, [Types::Field], null: false

  def fields
    context[:tournament].fields.where.not(lat: nil, long: nil, geo_json: nil).all
  end

  field :field, Types::Field, null: false do
    argument :id, ID, required: true
  end

  def field(id:)
    context[:tournament].fields.where.not(lat: nil, long: nil, geo_json: nil).find(id)
  end

  field :teams, [Types::Team], null: false

  def teams
    context[:tournament].teams.all
  end

  field :team, Types::Team, null: false do
    argument :id, ID, required: true
  end

  def team(id:)
    context[:tournament].teams.find(id)
  end

  field :divisions, [Types::Division], null: false

  def divisions
    context[:tournament].divisions.all
  end

  field :division, Types::Division, null: false do
    argument :id, ID, required: true
  end

  def division(id:)
    context[:tournament].divisions.find(id)
  end

  field :bracket, Types::Bracket, null: false do
    argument :handle, String, required: true
  end

  def bracket(handle:)
    BracketDb.find(handle: handle)
  end

  field :brackets, [Types::Bracket], null: false do
    argument :numTeams, Int, required: true
    argument :numDays, Int, required: true
  end

  def brackets(num_teams:, num_days:)
    BracketDb.where(teams: num_teams, days: num_days)
  end

  field :games, [Types::Game], null: false do
    argument :scheduled, Boolean, required: false
    argument :hasTeam, Boolean, required: false
  end

  def games(scheduled: false, has_team: false)
    scope = context[:tournament].games

    scope = scope.scheduled if scheduled
    scope = scope.has_team if has_team

    scope
  end

  field :game, Types::Game, null: false do
    argument :id, ID, required: true
  end

  def game(id:)
    context[:tournament].games.find(id)
  end

  field :score_reports, [Types::ScoreReport], auth: :required, null: false

  def score_reports
    context[:tournament].score_reports.all
  end

  field :score_report, Types::ScoreReport, auth: :required, null: false do
    argument :id, ID, required: true
  end

  def score_report(id:)
    context[:tournament].score_reports.find(id)
  end

  field :score_disputes, [Types::ScoreDispute], auth: :required, null: false

  def score_disputes
    context[:tournament].score_disputes.all
  end
end
