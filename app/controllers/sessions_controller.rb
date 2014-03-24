class SessionsController < ApplicationController

  def callback
    access_token = auth_hash['credentials']['token']
    session[:heroku_token] = access_token
    redirect_to :root
  end

  def logout
    session.destroy
    redirect_to :root
  end

  private

  def auth_hash
    request.env['omniauth.auth']
  end

end
