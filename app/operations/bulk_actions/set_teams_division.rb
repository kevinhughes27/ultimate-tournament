class BulkActions::SetTeamsDivision < ApplicationOperation
  input :tournament_id, type: :keyword, required: true
  input :ids, type: :keyword, required: true
  input :arg, type: :keyword, required: true

  attr_reader :status, :response

  def execute
    if teams.all? {|t| t.safe_to_change? }
      teams.update_all(division_id: division.id)
      teams.reload
      @response = render_response(teams)
      @status = 200
    else
      @response = {message: 'Cancelled: not all teams could be updated safely'}
      @status = 422
    end
  end

  private

  def division
    @division ||= Division.find_by(tournament_id: tournament_id, name: arg)
  end

  def teams
    @teams ||= Team.where(id: ids)
  end

  def render_response(teams)
    Admin::BulkActionsController.render(
      template: 'admin/teams/teams.json.jbuilder',
      layout: false,
      locals: {teams: teams}
    )
  end
end
