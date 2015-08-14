class Admin::ScheduleController < AdminController

  def index
    @games = @tournament.games.includes(:bracket)
    @fields = @tournament.fields.includes(:games).sort_by{|f| f.name.gsub(/\D/, '').to_i }
    @times = time_slots
  end

  def update
    games_params.each do |p|
      game = Game.find(p[:id])
      game.update_attributes(p)
    end

    head :ok
  end

  private

  def time_slots
    times = @games.pluck(:start_time).uniq
    times = times.compact if times.size > 1
    times.sort!
  end

  def games_params
    @games_params ||= params.permit(games: [
      :id,
      :field_id,
      :start_time
    ])
    @games_params[:games] ||= {}
    @games_params[:games].values
  end

end
