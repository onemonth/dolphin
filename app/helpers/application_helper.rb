module ApplicationHelper

  def heroku_api
    return nil unless dolphin
    return dolphin.heroku_api
  end

  def dolphin
    return nil unless session[:heroku_token]
    @_dolphin ||= DolphinCreator.new(session[:heroku_token])
  end

end
