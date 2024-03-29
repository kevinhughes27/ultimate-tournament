require 'test_helper'

class ChangeBracketTest < OperationTest
  setup do
    @division = FactoryBot.create(:division)
    @field = FactoryBot.create(:field)
  end

  test "re-creates games as spec'd by the bracket template" do
    type = 'single_elimination_4'
    template = BracketDb.find(handle: type).template
    template_game = template[:games].first

    ChangeBracket.perform(
      tournament_id: @tournament.id,
      division_id: @division.id,
      new_template: template
    )

    game = Game.find_by(division: @division, bracket_uid: template_game[:bracket_uid])

    assert game
    assert_equal template_game[:home_prereq].to_s, game.home_prereq
    assert_equal template_game[:away_prereq].to_s, game.away_prereq
  end

  test "games that are the same before and after are unaffected" do
    type = 'single_elimination_4'
    template = BracketDb.find(handle: type).template
    template_game = template[:games].first

    game = Game.from_template(
      tournament_id: @tournament.id,
      division_id: @division.id,
      template_game: template_game
    )
    game.save!

    game.update_columns(field_id: @field.id)

    ChangeBracket.perform(
      tournament_id: @tournament.id,
      division_id: @division.id,
      new_template: template
    )

    game.reload
    assert_equal @field, game.field
  end
end
