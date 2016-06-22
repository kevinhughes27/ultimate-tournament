require 'test_helper'

class AppControllerTest < ActionController::TestCase
  include ActiveJob::TestHelper

  setup do
    @tournament = tournaments(:noborders)
    set_tournament(@tournament)
    @report = score_reports(:swift_goose)
    @token = score_report_confirm_tokens(:goose_confirm_token)
  end

  test "get show" do
    get :show
    assert_response :success
  end

  test "get show for non existent tournament 404s" do
    set_tournament('wat')
    get :show
    assert_response :not_found
  end

  test "create score report" do
    params = @report.attributes.merge(
      submitter_fingerprint: 'some_fingerprint'
    )

    assert_difference "ScoreReport.count", +1 do
      post :score_submit, params: params, format: :json
    end
  end

  test "create score report with error" do
    params = @report.attributes.merge(
      team_score: -1,
      submitter_fingerprint: 'some_fingerprint'
    )

    post :score_submit, params: params, format: :json
    assert_response :unprocessable_entity
    assert_match 'must be greater than or equal to 0', @response.body
  end

  test "get confirm page" do
    get :confirm, params: { id: @token.id, token: @token.token }
    assert_response :ok
    assert_template :confirm
  end

  test "get confirm page without token param 404s" do
    get :confirm, params: { id: @token.id }
    assert_response :not_found
    assert_template 'token_not_found'
  end

  test "confirm a score report" do
    game = @report.game
    game.update_columns(home_score: nil, away_score: nil, score_confirmed: false)
    refute game.score_confirmed

    params = {
      id: @token.id,
      token: @token.token,
      game_id: game.id,
      team_id: @report.other_team.id,
      team_score: @report.opponent_score,
      opponent_score: @report.team_score,
      rules_knowledge: 3,
      fouls: 3,
      fairness: 3,
      attitude: 3,
      communication: 3,
      comments: '',
      submitter_fingerprint: 'fingerprint'
    }

    assert_difference "ScoreReport.count", +1 do
      perform_enqueued_jobs do
        post :confirm, params: params
      end
      assert_response :ok
      assert_template 'confirm_score_success'
    end

    assert game.reload.score_confirmed
  end

  test "confirm a score report requires token" do
    params = @report.attributes.merge(
      id: @token.id,
      submitter_fingerprint: 'fingerprint'
    )

    assert_no_difference "ScoreReport.count" do
      post :confirm, params: params
      assert_response :not_found
      assert_template 'token_not_found'
    end
  end

  test "report a different score" do
    game = @report.game
    game.update_columns(home_score: nil, away_score: nil, score_confirmed: false)
    refute game.score_confirmed

    params = {
      id: @token.id,
      token: @token.token,
      game_id: game.id,
      team_id: @report.other_team.id,
      team_score: @report.opponent_score + 1,
      opponent_score: @report.team_score,
      rules_knowledge: 3,
      fouls: 3,
      fairness: 3,
      attitude: 3,
      communication: 3,
      comments: '',
      submitter_fingerprint: 'fingerprint'
    }

    assert_difference "ScoreReport.count", +1 do
      perform_enqueued_jobs do
        post :confirm, params: params
      end
      assert_response :ok
      assert_template 'submit_score_success'
    end

    refute game.reload.score_confirmed
  end
end
