require 'test_helper'

class PlayerAppControllerTest < ActionController::TestCase
  setup do
    @tournament = FactoryBot.create(:tournament)
    FactoryBot.create(:map, tournament: @tournament)
    set_tournament(@tournament)
  end

  test "get index" do
    get :index
    assert_response :success
  end

  test "get index for non existent tournament 404s" do
    set_tournament('wat')
    get :index
    assert_response :not_found
  end
end
