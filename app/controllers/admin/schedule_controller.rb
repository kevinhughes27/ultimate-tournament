class Admin::ScheduleController < AdminController
  def index
    load_games
    load_fields
    respond_to do |format|
      format.html
      format.pdf do
        load_divisions
        render pdf: 'schedule', orientation: 'Landscape'
      end
    end
  end

  def update
    input = params_to_input(schedule_params)

    result = execute_graphql(
      'scheduleGame',
      'ScheduleGameInput',
      input,
      "{
         success
         message
         userErrors { field message }
         game { id fieldId startTime endTime }
       }"
    )

    game = Game.new(result_to_attributes(result, 'game'))

    if result['success']
      render json: {
        game_id: game.id,
        field_id: game.field_id,
        start_time: game.start_time,
        end_time: game.end_time,
        updated_at: Time.now
      }
    else
      error = if result['message'].present?
        result['message']
      elsif result['userErrors']
        result_to_errors(result).first
      end

      render json: {
        game_id: game.id,
        field_id: game.field_id,
        start_time: game.start_time,
        end_time: game.end_time,
        updated_at: Time.now,
        error: error
      }, status: :unprocessable_entity
    end
  end

  def destroy
    game = Game.find_by(tournament_id: @tournament.id, id: params[:game_id])
    game.unschedule!
    head :ok
  end

  # def bulk_update
  #   ActiveRecord::Base.transaction do
  #     # reset field and start times first so swapping can work.
  #     # Otherwise it might trigger conflict validations.
  #     game_ids = games_params.map{ |p| p[:id].to_i }
  #     games = Game.where(tournament_id: @tournament.id, id: game_ids)
  #     games.update_all(field_id: nil, start_time: nil)
  #
  #     games_params.each do |p|
  #       @game = Game.find_by(tournament_id: @tournament.id, id: p[:id])
  #       if p[:field_id].present? && p[:start_time].present?
  #         GameSchedule.perform(@game, p[:field_id], p[:start_time])
  #       end
  #     end
  #   end
  #
  #   load_index_data
  #   render :index
  #
  # rescue => e
  #   render json: {game_id: @game.id, error: e.message}, status: :unprocessable_entity
  # end

  private

  def load_games
    @games = @tournament.games.includes(
      :division,
      :home,
      :away,
      :score_reports,
      :score_disputes
    ).order(:division_id, :start_time)
  end

  def load_fields
    @fields = @tournament.fields.sort_by{ |f| f.name.gsub(/\D/, '').to_i }
  end

  def load_divisions
    @divisions = @tournament.divisions.includes(:teams, games: [:home, :away])
  end

  def schedule_params
    params.slice(:game_id, :field_id, :start_time, :end_time)
  end
end
