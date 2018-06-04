class Inputs::UpdateScoreInput < Inputs::BaseInputObject
  argument :gameId, ID, required: true
  argument :homeScore, Int, required: true
  argument :awayScore, Int, required: true
  argument :force, Boolean, required: false
  argument :resolve, Boolean, required: false
end