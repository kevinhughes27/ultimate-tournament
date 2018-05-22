require 'test_helper'

class SubmitScoreTest < ApiTest
  setup do
    @game = FactoryGirl.create(:game)
  end

  test "success" do
    execute_graphql("submitScore", "SubmitScoreInput", input)
    assert_success
  end

  test "error" do
    @input = input.delete(:home_score)
    execute_graphql("submitScore", "SubmitScoreInput", @input,
      expect_error: "Variable input of type SubmitScoreInput! was provided invalid value")
  end

  test 'submitting a score report emails the other team' do
    ScoreReportMailer.expects(:notify_team_email).with(
      @game.away,
      @game.home,
      instance_of(ScoreReport)
    ).returns(stub(:deliver_later))

    execute_graphql("submitScore", "SubmitScoreInput", input)
  end

  test 'submitting a score report creates a score report' do
    assert_difference "ScoreReport.count", +1 do
      execute_graphql("submitScore", "SubmitScoreInput", input)
    end
  end

  test 'when tournament confirm_setting is automatic' do
    @tournament.update_columns(game_confirm_setting: 'automatic')
    execute_graphql("submitScore", "SubmitScoreInput", input)
    assert @game.reload.score_confirmed
  end

  test 'when tournament confirm_setting is multiple and both teams submit' do
    @tournament.update_columns(game_confirm_setting: 'multiple')
    execute_graphql("submitScore", "SubmitScoreInput", input)
    refute @game.reload.score_confirmed

    second_input = input.merge(
      team_id: @game.away.id,
      submitter_fingerprint: 'fingerprint2'
    )

    execute_graphql("submitScore", "SubmitScoreInput", second_input)
    assert @game.reload.score_confirmed
  end

  test 'when tournament confirm_setting is multiple and one team submits twice' do
    @tournament.update_columns(game_confirm_setting: 'multiple')
    execute_graphql("submitScore", "SubmitScoreInput", input)
    refute @game.reload.score_confirmed

    second_input = input.merge(
      submitter_fingerprint: 'fingerprint2'
    )

    execute_graphql("submitScore", "SubmitScoreInput", second_input)
    refute @game.reload.score_confirmed
  end

  test 'when tournament confirm_setting is multiple and one device submits twice' do
    @tournament.update_columns(game_confirm_setting: 'multiple')
    execute_graphql("submitScore", "SubmitScoreInput", input)
    refute @game.reload.score_confirmed

    second_input = input.merge(
      team_id: @game.away.id
    )

    execute_graphql("submitScore", "SubmitScoreInput", second_input)
    refute @game.reload.score_confirmed
  end

  test 'when tournament confirm_setting is multiple and reports dont match' do
    @tournament.update_columns(game_confirm_setting: 'multiple')
    execute_graphql("submitScore", "SubmitScoreInput", input)
    refute @game.reload.score_confirmed

    second_input = input.merge(
      team_id: @game.away.id,
      submitter_fingerprint: 'fingerprint2',
      home_score: 3,
      away_score: 15
    )

    execute_graphql("submitScore", "SubmitScoreInput", second_input)
    refute @game.reload.score_confirmed
  end

  [:automatic, :multiple].each do |setting|
    test "reporting a different score creates a dispute with confirm setting #{setting}" do
      @tournament.update_columns(game_confirm_setting: setting)
      execute_graphql("submitScore", "SubmitScoreInput", input)

      second_input = input.merge(
        home_score: 3,
        away_score: 15
      )

      assert_difference "ScoreDispute.count", +1 do
        execute_graphql("submitScore", "SubmitScoreInput", second_input)
      end
    end
  end

  test 'doesnt create a second score dispute' do
    execute_graphql("submitScore", "SubmitScoreInput", input)

    second_input = input.merge(
      home_score: 3,
      away_score: 15
    )

    assert_difference "ScoreReport.count", +2 do
      assert_difference "ScoreDispute.count", +1 do
        execute_graphql("submitScore", "SubmitScoreInput", second_input)
        execute_graphql("submitScore", "SubmitScoreInput", second_input)
      end
    end
  end

  private

  def input
    {
      game_id: @game.id,
      team_id: @game.home.id,
      submitter_fingerprint: 'fingerprint',
      home_score: 15,
      away_score: 13,
      rules_knowledge: 3,
      fouls: 3,
      fairness: 3,
      attitude: 3,
      communication: 3,
      comments: 'comment'
    }
  end
end