class Admin::DivisionsController < AdminController

  before_action :load_division, only: [:show, :update, :destroy, :update_teams, :seed]
  before_action :check_seed_safety, only: [:seed]

  def index
    @divisions = @tournament.divisions
  end

  def show
  end

  def new
    @division = @tournament.divisions.build
  end

  def create
    @division = @tournament.divisions.create(division_params)
    respond_with @division
  end

  def update
    @division.update_attributes(division_params)
    respond_with @division
  end

  def destroy
    if params[:confirm] == 'true' || @division.safe_to_delete?
      @division.destroy()
      respond_with @division
    else
      render partial: 'confirm_delete', status: :unprocessable_entity
    end
  end

  def update_teams
    @teams = Team.where( id: params[:team_ids] )
    @teams.each_with_index do |team, idx|
      team.update_attribute( :seed, params[:seeds][idx] )
    end

    flash.now[:notice] = 'Seeds updated'
    render :show
  end

  def seed
    begin
      @division.seed
      flash.now[:notice] = 'Division seeded'
    rescue => error
      flash.now[:error] = error.message
    ensure
      render :show
    end
  end

  private

  def check_seed_safety
    unless params[:confirm] == 'true' || @division.safe_to_seed?
      render partial: 'confirm_seed', status: :unprocessable_entity
    end
  end

  def load_division
    @division = @tournament.divisions.find(params[:id])
  end

  def division_params
    @bracket_params ||= params.require(:division).permit(
      :name,
      :num_teams,
      :bracket_type
    )
  end
end
