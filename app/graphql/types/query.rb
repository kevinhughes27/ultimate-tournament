class Types::Query < Types::BaseObject
  field :settings, Types::Settings, null: true

  def settings
    context[:tournament]
  end

  field :map, Types::Map, null: true

  def map
    context[:tournament].map
  end

  field :fields, [Types::Field], null: true

  def fields
    context[:tournament].fields.all
  end

  field :field, Types::Field, null: true do
    argument :id, ID, required: true
  end

  def field(id:)
    context[:tournament].fields.find(id)
  end

  field :teams, [Types::Team], null: true

  def teams
    context[:tournament].teams.all
  end

  field :team, Types::Team, null: true do
    argument :id, ID, required: true
  end

  def team(id:)
    context[:tournament].teams.find(i)
  end

  field :divisions, [Types::Division], null: true

  def divisions
    context[:tournament].divisions.all
  end

  field :division, Types::Division, null: true do
    argument :id, ID, required: true
  end

  def division(id:)
    context[:tournament].divisions.find(id)
  end

  field :games, [Types::Game], null: true do
    argument :scheduled, Boolean, required: false
    argument :hasTeam, Boolean, required: false
  end

  def games(scheduled: false, has_team: false)
    scope = context[:tournament].games

    scope = scope.scheduled if scheduled
    scope = scope.has_team if has_team

    scope = scope.includes(:home, :away, :field)
    scope
  end

  field :game, Types::Game, null: true do
    argument :id, ID, required: true
  end

  def game(id:)
    context[:tournament].game.find(args[:id])
  end

  field :score_reports, [Types::ScoreReport], null: true

  def score_reports
    context[:tournament].score_reports.all
  end

  field :score_report, Types::ScoreReport, null: true do
    argument :id, ID, required: true
  end

  def score_report(id:)
    context[:tournament].score_report.find(args[:id])
  end
end
