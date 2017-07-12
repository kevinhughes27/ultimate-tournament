class Admin::ScheduleController < AdminController
  before_action :load_index_data, only: [:index]

  def index
    respond_to do |format|
      format.html
      format.pdf do
        load_divisions
        render pdf: 'schedule', orientation: 'Landscape'
      end
    end
  end

  def update
    game = Game.includes(
      :division,
      :home,
      :away,
      :score_reports,
      :score_disputes
    ).find_by(tournament_id: @tournament.id, id: params[:game_id])

    ScheduleGame.perform(game, params[:field_id], params[:start_time])
    render json: {
      game_id: game.id,
      start_time: game.start_time,
      end_time: game.end_time
    }
  rescue => e
    render json: {
      game_id: game.id,
      start_time: game.start_time,
      end_time: game.end_time,
      error: e.message
    }, status: :unprocessable_entity
  end

  def destroy
    game = Game.find_by(tournament_id: @tournament.id, id: params[:game_id])
    game.update(field_id: nil, start_time: nil)
    head :ok
  end

  def bulk_update
    ActiveRecord::Base.transaction do
      # reset field and start times first so swapping can work.
      # Otherwise it might trigger conflict validations.
      game_ids = games_params.map{ |p| p[:id].to_i }
      games = Game.where(tournament_id: @tournament.id, id: game_ids)
      games.update_all(field_id: nil, start_time: nil)

      games_params.each do |p|
        @game = Game.find_by(tournament_id: @tournament.id, id: p[:id])
        if p[:field_id].present? && p[:start_time].present?
          ScheduleGame.perform(@game, p[:field_id], p[:start_time])
        end
      end
    end

    load_index_data
    render :index

  rescue => e
    render json: {game_id: @game.id, error: e.message}, status: :unprocessable_entity
  end

  private

  def load_index_data
    @games = @tournament.games.includes(
      :division,
      :home,
      :away,
      :score_reports,
      :score_disputes
    ).order(division_id: :asc)

    @fields = @tournament.fields.sort_by{ |f| f.name.gsub(/\D/, '').to_i }
  end

  def load_divisions
    @divisions = @tournament.divisions.includes(:teams, games: [:home, :away])
  end
end
