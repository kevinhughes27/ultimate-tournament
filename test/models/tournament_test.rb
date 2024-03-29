require 'test_helper'

class TournamentTest < ActiveSupport::TestCase
  test "tournament requires a name" do
    tournament = Tournament.new
    refute tournament.valid?
    assert_equal ["can't be blank"], tournament.errors[:name]
  end

  test "tournament name must be unique" do
    FactoryBot.create(:tournament, name: 'No Borders')
    tournament = Tournament.new(name: 'No Borders', handle: 'new-handle')
    refute tournament.save
    assert_equal ["has already been taken"], tournament.errors[:name]
  end

  test "tournament requires a handle" do
    tournament = Tournament.new(name: 'No Borders')
    refute tournament.valid?
    assert_equal ["can't be blank", 'is invalid'], tournament.errors[:handle]
  end

  test "tournament handle must be unique" do
    FactoryBot.create(:tournament, handle: 'no-borders')
    tournament = Tournament.new(name: 'New Tournament', handle: 'no-borders')
    refute tournament.save
    assert_equal ["has already been taken"], tournament.errors[:handle]
  end

  test "www is invalid handle" do
    tournament = Tournament.new(name: 'New Tournament', handle: 'www')
    refute tournament.save
    assert_equal ["is reserved"], tournament.errors[:handle]
  end

  test "handle is downcased" do
    tournament = Tournament.new(name: 'New Tournament', handle: 'New-Tournament')
    assert tournament.save
    assert_equal "new-tournament", tournament.handle
  end

  test "tournament requires at least one tournament user" do
    tournament = FactoryBot.create(:tournament)
    refute tournament.valid?
    assert_equal ["can't be blank"], tournament.errors[:tournament_users]
  end

  test "deleting a tournament deletes all its data" do
    tournament = FactoryBot.create(:tournament)
    tournament.destroy

    assert Map.where(tournament: tournament).empty?
    assert Field.where(tournament: tournament).empty?
    assert Team.where(tournament: tournament).empty?
    assert Division.where(tournament: tournament).empty?
    assert Game.where(tournament: tournament).empty?
    assert ScoreReport.where(tournament: tournament).empty?
  end

  test "save pin" do
    tournament = FactoryBot.build(:tournament, score_submit_pin: '1234')
    assert tournament.valid?
  end

  test "pin must be 4 chars" do
    tournament = FactoryBot.build(:tournament, score_submit_pin: '12345')
    refute tournament.valid?
    assert_equal ["is the wrong length (should be 4 characters)"],
      tournament.errors[:score_submit_pin]
  end

  test "pin must be only numbers" do
    tournament = FactoryBot.build(:tournament, score_submit_pin: '123a')
    refute tournament.valid?
    assert_equal ["is invalid"],
      tournament.errors[:score_submit_pin]
  end

  test "pin can be blank" do
    tournament = FactoryBot.build(:tournament, score_submit_pin: '')
    assert tournament.valid?
  end
end
