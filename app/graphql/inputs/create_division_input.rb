class Inputs::CreateDivisionInput < Inputs::BaseInputObject
  argument :name, String, required: false
  argument :numTeams, Int, required: false
  argument :numDays, Int, required: false
  argument :bracketType, String, required: false
end
