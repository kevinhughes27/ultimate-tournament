require 'test_helper'

class SafeToUpdateBracketCheckTest < ActiveJob::TestCase
  test "update is safe if no games are scheduled or played" do
    division = FactoryGirl.create(:game).division
    check = SafeToUpdateBracketCheck.new(division)
    check.perform
    assert check.succeeded?
  end

  test "unsafe if games are scheduled" do
    division = FactoryGirl.create(:scheduled_game).division
    check = SafeToUpdateBracketCheck.new(division)
    check.perform
    refute check.succeeded?
    assert_match 'have been scheduled', check.message
  end

  test "unsafe if games are played" do
    division = FactoryGirl.create(:game, :finished).division
    check = SafeToUpdateBracketCheck.new(division)
    check.perform
    refute check.succeeded?
    assert_match 'have been scored', check.message
  end
end
