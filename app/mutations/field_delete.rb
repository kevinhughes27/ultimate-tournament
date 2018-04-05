class FieldDelete < MutationOperation
  input :field, accepts: Field, required: true
  input :confirm, default: false, type: :keyword

  def execute
    halt 'confirm_delete' if !(confirm == 'true' || field.safe_to_delete?)

    Field.transaction do
      field.destroy!
      unschedule_games(field.id)
    end
  end

  def confirmation_required?
    halted? && @output == 'confirm_delete'
  end

  private

  def unschedule_games(field_id)
    Game.where(field_id: field_id).update_all(field_id: nil, start_time: nil)
  end
end
