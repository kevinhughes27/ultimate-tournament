require 'test_helper'

class CreatePlacesJobTest < ActiveJob::TestCase
  setup do
    @tournament = tournaments(:noborders)
    @division = divisions(:open)
  end

  test "creates places as spec'd by the bracket template" do
    type = 'single_elimination_8'
    template = Bracket.find_by(handle: type).template
    template_place = template[:places].first

    CreatePlacesJob.perform_now(
      tournament_id: @tournament.id,
      division_id: @division.id,
      template: template
    )

    assert Place.find_by(division: @division, prereq: template_place[:prereq])
  end
end