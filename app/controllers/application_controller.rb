class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  helper ApplicationHelper
  include ApplicationHelper
end
