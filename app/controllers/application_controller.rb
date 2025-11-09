class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?
  allow_browser versions: :modern

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: %i[name introduction])
    devise_parameter_sanitizer.permit(:account_update, keys: %i[name introduction])
  end
end
