class Inputs::UpdateSettingsInput < Inputs::BaseInputObject
  argument :name, String, required: false
  argument :handle, String, required: false
  argument :scoreSubmitPin, Types::PinCode, required: false
  argument :gameConfirmSetting, String, required: false
  argument :timezone, String, required: false
  argument :confirm, Boolean, required: false
end
