class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def authenticate_app
    api_key = params[:api_key]

    unless api_key == ENV['tvdb_api_key'] or api_key == ENV['trakt_api_key']
      render json: {
        message: "Invalid Authentication Details"
      }
    end
  end
end
