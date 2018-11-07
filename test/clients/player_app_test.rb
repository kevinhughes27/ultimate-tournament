require "test_helper"

class PlayerAppBrowserTest < BrowserTestCase
  setup do
    @tournament = FactoryBot.create(:tournament, handle: 'no-borders')
    @map = FactoryBot.create(:map, tournament: @tournament)
    @team = FactoryBot.create(:team, name: 'Swift')
    @opponent = FactoryBot.create(:team, name: 'Goose')
    @game = FactoryBot.create(:game, :scheduled, home: @team, away: @opponent)
  end

  test 'submit a score' do
    visit_app
    search_for_team('Swift')
    navigate_to_submit
    click_on_game(@game)
    enter_score(15, 11)
    submit_score

    assert_submitted
    assert_report('Swift', @game, 15, 11)
  end

  test 'submit a score (with pin)' do
    @tournament.update_column(:score_submit_pin, '1234')

    visit_app
    search_for_team('Swift')
    navigate_to_submit
    enter_pin('1234')
    click_on_game(@game)
    enter_score(15, 11)
    submit_score

    assert_submitted
    assert_report('Swift', @game, 15, 11)
  end

  test 'submit a score (lowercase search)' do
    visit_app
    search_for_team('swift')
    navigate_to_submit
    click_on_game(@game)
    enter_score(15, 11)
    submit_score

    assert_submitted
    assert_report('Swift', @game, 15, 11)
  end

  test 'deep link' do
    report = FactoryBot.create(:score_report, game: @game, team: @team)

    deep_link = report.build_confirm_link

    visit(deep_link)
    enter_comment('Yup thats the score')
    submit_score

    assert_submitted
    assert_confirmed_report(report, comment: 'Yup thats the score')
  end

  private

  def visit_app
    visit("http://#{@tournament.handle}.#{Settings.host}/")
  end

  def search_for_team(value)
    fill_in(placeholder: 'Search Teams', with: value)
  end

  def navigate_to_submit
    click_on('Submit Score')
  end

  def enter_pin(pin)
    input = first('input.pincode-input-text')
    input.send_keys pin
  end

  def click_on_game(game)
    click_on("#{game.home_name} vs #{game.away_name}")
  end

  def enter_score(home, away)
    fill_in('homeScore', with: home)
    fill_in('awayScore', with: away)
  end

  def enter_comment(text)
    fill_in('comments', with: text)
  end

  def submit_score
    click_on('Submit')
  end

  def assert_submitted
    assert page.find("svg[color='green']")
  end

  def assert_report(team, game, home, away)
    report = ScoreReport.last
    assert_equal team, report.team.name
    assert_equal game, report.game
    assert_equal home, report.home_score
    assert_equal away, report.away_score
    assert report.submitter_fingerprint
  end

  def assert_confirmed_report(report, comment:)
    confirmed_report = ScoreReport.last
    assert_equal confirmed_report.team.name, report.other_team.name
    assert_equal confirmed_report.game, report.game
    assert_equal confirmed_report.home_score, report.home_score
    assert_equal confirmed_report.away_score, report.away_score
    assert confirmed_report.comments, comment
    assert confirmed_report.submitter_fingerprint
  end
end