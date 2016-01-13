require "test_helper"

class AppBrowserTest < ActiveSupport::TestCase
  include Capybara::DSL
  self.use_transactional_fixtures = false

  setup do
    @tournament = tournaments(:noborders)
  end

  test "drawer is closed" do
    visit("/#{@tournament.handle}")
    refute page.find("#drawer")[:class].include?("active"), 'Drawer is open'
  end

  test "find opens the drawer" do
    visit("/#{@tournament.handle}")
    click_on('Find')
    assert page.find("#drawer")[:class].include?("active"), 'Drawer is not open'
  end

  test "user views the schedule screen and performs a search" do
    visit("/#{@tournament.handle}")

    # navigate to schedule screen
    refute page.find("#schedule-screen")[:class].include?("active")
    click_on('Schedule')
    assert page.find("#schedule-screen")[:class].include?("active")

    within("#schedule-screen") do
      # all games shown prior to search
      refute page.find("#game-#{games(:swift_goose).id}")[:class].include?("hide")
      refute page.find("#game-#{games(:pheonix_mavericks).id}")[:class].include?("hide")

      # perform the search
      find(".team-search input").set("Swift")
      find(".team-search li").click

      # only matched games shown after search
      refute page.find("#game-#{games(:swift_goose).id}")[:class].include?("hide")
      assert page.find("#game-#{games(:pheonix_mavericks).id}")[:class].include?("hide")
    end
  end

  test "user can submit a score" do
    visit("/#{@tournament.handle}")

    # navigate to schedule screen
    refute page.find("#submit-score-screen")[:class].include?("active")
    click_on('Submit a score')
    assert page.find("#submit-score-screen")[:class].include?("active")

    within("#submit-score-screen") do
      # perform the search
      find(".team-search input").set("Swift")
      find(".team-search li").click

      # only matched games are visible
      refute page.find("#game-#{games(:swift_goose).id}")[:class].include?("hide")
      assert page.find("#game-#{games(:pheonix_mavericks).id}")[:class].include?("hide")

      # pick game
      find("#game-#{games(:swift_goose).id} a").click
    end

    assert page.find("#submit-score-form")[:class].include?("active")

    within("#submit-score-form") do
      fill_in('team_score', :with => 15)
      fill_in('opponent_score', :with => 11)
      choose('rules_knowledge_3')
      choose('fouls_2')
      choose('fairness_3')
      choose('attitude_3')
      choose('communication_3')
      fill_in('comments', :with => "Great game Goose!")
      click_on("Submit")
    end

    wait_for_ajax
    assert page.find("#submit-score-success")[:class].include?("active")

    report = ScoreReport.last
    assert_equal 'Swift', report.team.name
    assert_equal games(:swift_goose), report.game
    assert_equal 15, report.team_score
    assert_equal 11, report.opponent_score
    assert report.submitter_fingerprint

    report.destroy!
  end
end
