require 'test_helper'

class BracketSimulationTest < OperationTest
  MAX_SIMULATION_TIME = 10

  BracketDb.all.each do |handle, bracket|
    test "play a division with bracket_type: #{handle}" do
      @division = create_division(bracket_type: handle)

      create_seeds
      seed_division

      play_games

      assert_winner
      assert_places
    end
  end

  private

  def create_division(bracket_type:)
    params = FactoryBot.attributes_for(:division, bracket_type: bracket_type)
    input = params.except(:tournament)
    execute_graphql("createDivision", "CreateDivisionInput", input)
    Division.last
  end

  def create_seeds
    n = @division.bracket.teams

    (1..n).map do |rank|
      FactoryBot.create(:seed, division: @division, rank: rank)
    end
  end

  def seed_division
    execute_graphql("seedDivision", "SeedDivisionInput", {division_id: @division.id})
    assert @division.reload.seeded?, 'Seeding failed'
  end

  # loop until games are done
  def play_games
    with_timeout do
      while games_to_be_played.present? do
        games_to_be_played.each do |game|
          play_game(game)
        end
      end

      # simulation got stuck. this is bad
      # the bracket logic has at least 1 unfinishable outcome
      if unfinished_games.present?
        raise "Not all games completed but none can be played\n#{unfinished_games.map(&:bracket_uid)}"
      end
    end

  end

  def with_timeout
    if ENV['CI']
      Timeout::timeout(MAX_SIMULATION_TIME) do
        yield
      end
    else
      yield
    end
  rescue Timeout::Error
    raise "Simulation took too long"
  end

  def play_game(game)
    score = gen_score
    SaveScore.perform(
      game: game,
      home_score: score[0],
      away_score: score[1]
    )
  end

  def gen_score
    score1 = Faker::Number.between(from: 1, to: 15)
    score2 = Faker::Number.between(from: 1, to: 15)

    while score2 == score1
      score2 = Faker::Number.between(from: 1, to: 15)
    end

    [score1, score2]
  end

  def games_to_be_played
    @division.games.with_teams.where(score_confirmed: false)
  end

  def unfinished_games
    @division.games.where(score_confirmed: false)
  end

  def assert_winner
    place = @division.places.find_by(position: 1)
    assert place.team, "No Winner found"
  end

  def assert_places
    @division.places.each do |place|
      assert place.team, "place #{place.position} missing team"
    end

    @division.teams.each do |team|
      place = Place.find_by(division: @division, team: team)
      assert place, "team missing place, games_uids: #{games_uids_for_team(team)}"
    end
  end

  def games_uids_for_team(team)
    game_uids = []
    game_uids << Game.where(division: @division, home: team).pluck(:bracket_uid, :pool)
    game_uids << Game.where(division: @division, away: team).pluck(:bracket_uid, :pool)
    game_uids.flatten.compact.uniq
  end
end
