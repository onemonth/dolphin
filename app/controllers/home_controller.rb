class HomeController < ApplicationController

  def index
    @app_info = dolphin.get_app
    @debug = dolphin.heroku_token
  end

  def app_info
    return unless heroku_api
    return dolphin.get_app
  end
end