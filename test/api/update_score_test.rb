require 'test_helper'

class UpdateScoreTest < ApiTest
  setup do
    login_user
    @output = '{ success, userErrors }'
  end

  test "update a games score" do
    game = FactoryGirl.create(:game)
    input = {game_id: game.id, home_score: 15, away_score: 13}
    execute_graphql("updateScore", "UpdateScoreInput", input, @output)
    assert_success
    assert_equal 15, game.reload.home_score
    assert_equal 13, game.away_score
  end

  test "can't update score if not safe (mock)" do
    game = FactoryGirl.create(:game)
    SafeToUpdateScoreCheck.expects(:perform).returns(false)

    input = {game_id: game.id, home_score: 14, away_score: 12}

    execute_graphql("updateScore", "UpdateScoreInput", input, @output)
    assert_failure "unsafe score update"
  end

  test "can't update score if not safe" do
    game1 = FactoryGirl.create(:game, :finished)
    game2 = FactoryGirl.create(:game, :finished, home_prereq: "W#{game1.bracket_uid}")

    input = {game_id: game1.id, home_score: game1.away_score, away_score: game1.home_score}

    execute_graphql("updateScore", "UpdateScoreInput", input, @output)
    assert_failure "unsafe score update"
  end

  test "force unsafe update (mock)" do
    game = FactoryGirl.create(:game)
    SafeToUpdateScoreCheck.expects(:perform).never

    input = {game_id: game.id, home_score: 14, away_score: 12, force: true}

    execute_graphql("updateScore", "UpdateScoreInput", input, @output)

    assert_success
    assert_equal 14, game.reload.home_score
    assert_equal 12, game.away_score
  end

  test "force unsafe update" do
    game1 = FactoryGirl.create(:game, :finished)
    game2 = FactoryGirl.create(:game, :finished, home_prereq: "W#{game1.bracket_uid}")

    new_home_score = game1.away_score
    new_away_score = game1.home_score
    input = {game_id: game1.id, home_score: new_home_score, away_score: new_away_score, force: true}

    execute_graphql("updateScore", "UpdateScoreInput", input, @output)

    assert_success
    assert_equal new_home_score, game1.reload.home_score
    assert_equal new_away_score, game1.away_score
  end

  test "can't update score unless teams" do
    game = FactoryGirl.create(:game, home: nil, away: nil)

    input = {game_id: game.id, home_score: 10, away_score: 5}

    execute_graphql("updateScore", "UpdateScoreInput", input, @output)

    assert_failure "teams not present"
    assert_nil game.home_score
    assert_nil game.away_score
  end

  test "can't submit a tie for a bracket game" do
    game = FactoryGirl.create(:game)

    input = {game_id: game.id, home_score: 5, away_score: 5}

    execute_graphql("updateScore", "UpdateScoreInput", input, @output)
    assert_failure "ties not allowed for this game"
  end

  test "can submit a tie for a pool game" do
    game = FactoryGirl.create(:pool_game)

    input = {game_id: game.id, home_score: 5, away_score: 5}

    execute_graphql("updateScore", "UpdateScoreInput", input, @output)

    assert_success
    assert_equal 5, game.reload.home_score
    assert_equal 5, game.away_score
  end

  test "confirms the game" do
    game = FactoryGirl.create(:game)
    input = {game_id: game.id, home_score: 15, away_score: 11}
    execute_graphql("updateScore", "UpdateScoreInput", input, @output)
    assert_success
    assert game.reload.confirmed?
  end

  test "creates ScoreEntry" do
    game = FactoryGirl.create(:game)
    assert_difference "ScoreEntry.count", +1 do
      input = {game_id: game.id, home_score: 15, away_score: 11}
      execute_graphql("updateScore", "UpdateScoreInput", input, @output)
      assert_success
    end
  end

  test "resolves any disputes" do
    game = FactoryBot.create(:game)
    dispute = ScoreDispute.create!(tournament: game.tournament, game_id: game.id, user: @user)
    game.reload

    input = {game_id: game.id, home_score: 15, away_score: 11, resolve: true}
    execute_graphql("updateScore", "UpdateScoreInput", input, @output)
    assert_success
    assert_equal 'resolved', dispute.reload.status
  end
end
