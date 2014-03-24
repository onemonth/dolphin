class HomeController < ApplicationController

  def index
    @info = heroku_api.get_user.body
    @apps = list_apps
  end

  def list_apps
    return [] unless heroku_api
    heroku_api.get_apps.body
  end

  def heroku_api
    return nil unless session[:heroku_token]
    @_heroku_api = Heroku::API.new(api_key: session[:heroku_token])
  end

end