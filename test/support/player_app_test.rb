require_relative 'browser_test'

class PlayerAppTest < BrowserTest
  setup do
    @tournament = FactoryBot.create(:tournament, handle: 'no-borders')
    @map = FactoryBot.create(:map, tournament: @tournament)
    @team = FactoryBot.create(:team, name: 'Swift')
    @opponent = FactoryBot.create(:team, name: 'Goose')
    @game = FactoryBot.create(:game, :scheduled, home: @team, away: @opponent)
  end

  protected

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
    # too fast on CI
    # input = first('input.pincode-input-text')
    # input.send_keys pin

    inputs = page.all('input.pincode-input-text')

    inputs[0].set pin[0]
    inputs[1].set pin[1]
    inputs[2].set pin[2]
    inputs[3].set pin[3]
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

  def submit_win
    click_on('Submit Win')
  end

  def submit_loss
    click_on('Submit Loss')
  end

  def assert_submitted
    assert page.find('svg[style="color: green;"]')
  end

  def assert_report(team, game, home, away)
    report = ScoreReport.last
    assert_equal team, report.team.name
    assert_equal game, report.game
    assert_equal home, report.home_score
    assert_equal away, report.away_score
    assert report.submitter_fingerprint
  end

  def assert_comment(comment)
    report = ScoreReport.last
    assert_equal comment, report.comments
  end

  def assert_confirmed_report(report, comment:)
    confirmed_report = ScoreReport.last
    assert_equal confirmed_report.team.name, report.other_team.name
    assert_equal confirmed_report.game, report.game
    assert_equal confirmed_report.home_score, report.home_score
    assert_equal confirmed_report.away_score, report.away_score
    assert_equal comment, confirmed_report.comments
    assert confirmed_report.submitter_fingerprint
  end
end
