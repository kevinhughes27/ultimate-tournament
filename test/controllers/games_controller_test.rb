require 'test_helper'

class Admin::GamesControllerTest < ActionController::TestCase

  setup do
    http_login('admin', 'nobo')
    @tournament = tournaments(:noborders)
  end

  test "should get index" do
    get :index, tournament_id: @tournament.id
    assert_response :success
    assert_not_nil assigns(:games)
  end

end
