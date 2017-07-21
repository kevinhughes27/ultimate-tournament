require "test_helper"

class LoginBrowserTest < BrowserTestCase
  setup do
    @user = FactoryGirl.create(:user)
    @tournament = FactoryGirl.create(:tournament, handle: 'no-borders')
    FactoryGirl.create(:tournament_user, user: @user, tournament: @tournament)
  end

  test "login to tournament admin" do
    visit("http://no-borders.#{Settings.domain}/admin")

    assert_text 'Log in to manage your tournament'
    fill_in('user_email', with: @user.email)
    fill_in('user_password', with: 'password')
    click_on('Log in')

    assert_match /admin/, current_url
  end

  test "login from signup page" do
    visit("http://www.#{Settings.domain}/")
    click_on('Log in')

    assert_text 'Log in to manage your tournament'
    fill_in('user_email', with: @user.email)
    fill_in('user_password', with: 'password')
    click_on('Log in')

    assert_match /admin/, current_url
  end
end
