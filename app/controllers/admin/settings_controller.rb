class Admin::SettingsController < AdminController

  def show
  end

  def update
    update = UpdateSettings.new(@tournament, tournament_params, params[:confirm])
    update.perform

    if update.succeeded?
      flash[:notice] = 'Settings saved.'
      redirect_to admin_settings_url(subdomain: @tournament.handle)
    elsif update.confirmation_required?
      render partial: 'confirm_update', status: :unprocessable_entity
    else
      flash[:error] = 'Error saving Settings.'
      render :show
    end
  end

  def reset_data
    @tournament.reset_data!
    flash[:notice] = 'Data reset.'
    redirect_to admin_settings_path
  end

  private

  def tournament_params
    tournament_params = params.require(:tournament).permit(
      :name,
      :handle,
      :time_cap,
      :game_confirm_setting
    )

    tournament_params[:timezone] = Time.zone.name
    tournament_params
  end
end
