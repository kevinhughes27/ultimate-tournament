require "test_helper"

class TeamsTest < AdminTest
  test 'create team' do
    visit_app
    login
    side_menu('Teams')
    action_menu('Add Team')
    create_team
    logout
  end

  test 'update team' do
    @team = FactoryBot.create(:team, name: 'Swift')

    visit_app
    login
    side_menu('Teams')
    open_team
    edit_team
    logout
  end

  test 'import_teams' do
    visit_app
    login
    side_menu('Teams')
    action_menu('Import Teams')
    import_teams
    logout
  end

  private

  def create_team
    fill_in('name', with: 'Hug Machine')

    assert_difference 'Team.count' do
      submit
      assert_text ('Team created')
    end

    team = Team.last
    assert_equal 'Hug Machine', team.name
  end

  def open_team
    assert_text @team.name
    click_text(@team.name)
    assert_equal find_field('email').value, @team.email
  end

  def edit_team
    fill_in('name', with: ' ')
    fill_in('name', with: 'Hug Machine')
    submit
    assert_text ('Team updated')

    team = Team.last
    assert_equal 'Hug Machine', team.name
  end

  def import_teams
    assert_text('CSV File')
    attach_file('csvFile', Rails.root + 'test/files/teams.csv')

    assert_difference 'Team.count', +8 do
      submit
      assert_text 'Imported 8 teams'
      click_on('Done')
      assert_text "Nor'easter"
      assert_text 'Fiasco'
      assert_text 'Ocho'
    end
  end
end
