require 'test_helper'

class Admin::SettingsControllerTest < ActionController::TestCase
  setup do
    @tournament = tournaments(:noborders)
    set_tournament(@tournament)
    @user = users(:kevin)
    sign_in @user
  end

  test "get settings page" do
    get :show
  end

  test "update settings" do
    params = @tournament.attributes.merge(name: 'Updated Name')

    put :update, params: { tournament: params }
    assert_redirected_to admin_settings_url(subdomain: @tournament.handle)

    assert_equal 'Settings saved.', flash[:notice]
    assert_equal 'Updated Name', @tournament.reload.name
  end

  test "update handle requires confirm" do
    new_handle = 'new-handle'
    put :update, params: { tournament: {handle: new_handle} }
    assert_response :unprocessable_entity
    assert_template 'admin/settings/_confirm_update'
  end

  test "update handle redirects properly" do
    new_handle = 'new-handle'
    put :update, params: { tournament: {handle: new_handle}, confirm: 'true' }
    assert_redirected_to admin_settings_url(subdomain: new_handle)
    assert_equal new_handle, @tournament.reload.handle
  end

  test "update settings error" do
    put :update, params: { tournament: {name: '', handle: @tournament.handle} }
    assert_equal 'Error saving Settings.', flash[:error]
  end

  test "reset clears data" do
    post :reset_data
    assert_redirected_to admin_settings_path
    assert_equal 'Data reset.', flash[:notice]

    assert_equal 0, @tournament.reload.fields.count
    assert_equal 0, @tournament.reload.teams.count
    assert_equal 0, @tournament.reload.divisions.count
    assert_equal 0, @tournament.reload.games.count
    assert_equal 0, @tournament.reload.pool_results.count
    assert_equal 0, @tournament.reload.places.count
    assert_equal 0, @tournament.reload.score_reports.count
  end
end
