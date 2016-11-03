require 'test_helper'

class DivisionTest < ActiveSupport::TestCase
  setup do
    @tournament = tournaments(:noborders)
    @division = divisions(:open)
    @teams = @division.teams
  end

  test "division deletes games when it is deleted" do
    type = 'single_elimination_4'
    division = create_division(bracket_type: type)

    assert_difference "Game.count", -4 do
      division.destroy
    end
  end

  test "division deletes places when it is deleted" do
    type = 'single_elimination_4'
    division = create_division(bracket_type: type)

    assert_difference "Place.count", -4 do
      division.destroy
    end
  end

  test "division nullifies teams when it is deleted" do
    division = divisions(:open)

    teams = division.teams
    assert teams.present?

    division.destroy

    assert teams.reload.all? { |team| team.division.nil? }
  end

  test "dirty_seed? calls operation" do
    DirtySeedCheck.expects(:perform)
    @division.dirty_seed?
  end

  test "safe_to_delete? is true for division with no games started" do
    division = divisions(:women)
    assert division.safe_to_delete?
  end

  test "safe_to_delete? is false for division with games started" do
    division = divisions(:open)
    refute division.safe_to_delete?
  end

  test "limited number of divisions per tournament" do
    stub_constant(Division, :LIMIT, 2) do
      division = @tournament.divisions.build(name: 'new division')
      refute division.valid?
      assert_equal ['Maximum of 2 divisions exceeded'], division.errors[:base]
    end
  end

  test "limit is define" do
    assert_equal 12, Division::LIMIT
  end

  test "bracket_games scope" do
    type = 'USAU 4.2.1'
    division = create_division(bracket_type: type)

    bracket_games = division.bracket_games
    assert bracket_games.first.bracket_uid
  end

  test "pool_games scope" do
    type = 'USAU 4.2.1'
    division = create_division(bracket_type: type)

    pool_games = division.pool_games('A')
    assert_equal 'A', pool_games.first.pool
  end
end
