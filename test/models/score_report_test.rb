require 'test_helper'

class ScoreReportTest < ActiveSupport::TestCase
  test "submitter_won? returns true if the submitter won the game" do
    game = FactoryBot.create(:game)

    report = FactoryBot.build(:score_report,
      game: game,
      team: game.home,
      home_score: 15,
      away_score: 11
    )

    assert report.submitter_won?
  end

  test "submitter_won? returns false if the submitter lost the game" do
    game = FactoryBot.create(:game)

    report = FactoryBot.build(:score_report,
      game: game,
      team: game.home,
      home_score: 11,
      away_score: 15
    )

    refute report.submitter_won?
  end

  test "other_team" do
    game = FactoryBot.create(:game)

    report = FactoryBot.build(:score_report,
      game: game,
      team: game.home,
      home_score: 15,
      away_score: 11
    )

    assert_equal game.away, report.other_team
  end

  test "is soft deleted" do
    game = FactoryBot.create(:game)
    report = FactoryBot.create(:score_report, game: game)

    report.destroy()
    assert report.deleted?
  end

  test "soft deleted objects not in query" do
    game = FactoryBot.create(:game)
    report = FactoryBot.create(:score_report, game: game)

    report.destroy()
    assert_equal 0, ScoreReport.count
  end

  test "build_confirm_link" do
    report = FactoryBot.create(:score_report)
    link = URI(report.build_confirm_link)
    params = Rack::Utils.parse_query(link.query)

    assert_equal params['gameId'], report.game_id.to_s
    assert_equal params['teamName'], report.other_team.name
    assert_equal params['homeScore'], report.home_score.to_s
    assert_equal params['awayScore'], report.away_score.to_s
  end

  test "build_dispute_link" do
    report = FactoryBot.create(:score_report)
    link = URI(report.build_dispute_link)
    params = Rack::Utils.parse_query(link.query)

    assert_equal params['gameId'], report.game_id.to_s
    assert_equal params['teamName'], report.other_team.name
  end
end
