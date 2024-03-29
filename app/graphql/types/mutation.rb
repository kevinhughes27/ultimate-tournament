class Types::Mutation < Types::BaseObject
  # public
  field :submitScore, mutation: Mutations::SubmitScore
  field :checkPin,    mutation: Mutations::CheckPin

  # admin
  field :createTeam,     mutation: Mutations::CreateTeam,     auth: :required
  field :updateTeam,     mutation: Mutations::UpdateTeam,     auth: :required
  field :deleteTeam,     mutation: Mutations::DeleteTeam,     auth: :required

  field :createDivision, mutation: Mutations::CreateDivision, auth: :required
  field :updateDivision, mutation: Mutations::UpdateDivision, auth: :required
  field :deleteDivision, mutation: Mutations::DeleteDivision, auth: :required
  field :createSeed,     mutation: Mutations::CreateSeed,     auth: :required
  field :deleteSeed,     mutation: Mutations::DeleteSeed,     auth: :required
  field :seedDivision,   mutation: Mutations::SeedDivision,   auth: :required

  field :updateMap,      mutation: Mutations::UpdateMap,      auth: :required
  field :createField,    mutation: Mutations::CreateField,    auth: :required
  field :updateField,    mutation: Mutations::UpdateField,    auth: :required
  field :deleteField,    mutation: Mutations::DeleteField,    auth: :required

  field :scheduleGame,   mutation: Mutations::ScheduleGame,   auth: :required
  field :unscheduleGame, mutation: Mutations::UnscheduleGame, auth: :required

  field :updateScore,    mutation: Mutations::UpdateScore,    auth: :required

  field :updateSettings, mutation: Mutations::UpdateSettings, auth: :required

  field :addUser, mutation: Mutations::AddUser, auth: :required
  field :changeUserPassword, mutation: Mutations::ChangeUserPassword, auth: :required
end
