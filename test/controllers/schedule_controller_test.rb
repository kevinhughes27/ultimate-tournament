require 'test_helper'

class Admin::ScheduleControllerTest < ActionController::TestCase

  setup do
    http_login('admin', 'nobo')
    @tournament = tournaments(:noborders)
  end

  test "should get index" do
    get :index, tournament_id: @tournament.id
    assert_response :success
  end

  test "blank slate sets to time.now" do
    tournament = tournaments(:new_tournament)

    Timecop.freeze do
      get :index, tournament_id: tournament.id
      assert_response :success
      assert_match Time.now.to_formatted_s(:datetimepicker), response.body
    end
  end

end
