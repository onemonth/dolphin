class DolphinCreator

  attr_reader :heroku_token

  def initialize(token)
    @heroku_token = token
  end

  def heroku_api
    return @_heroku_api if @_heroku_api
    @_heroku_api = Heroku::API.new(api_key: heroku_token)
    @_heroku_api.get_user.body
    @_heroku_api
  rescue Heroku::API::Errors::Unauthorized
    @_heroku_api = nil
  end

  def get_app
    heroku_api.get_app(app_id).body
  rescue Heroku::API::Errors::NotFound
    nil
  end

  def app_id
    heroku_id = heroku_api.get_user.body["id"]
    id = heroku_id.split("@").first
    "dolphin-#{id}"
  end

  def create_app
    heroku_api.post_app(name: app_id)
    set_env_vars(app_id)
    add_logger(app_id)
    push_code(app_id)
    heroku_api.get_app(app_id).body
  rescue StandardError => e
    heroku_api.delete_app(app_id)
    raise e
  end

  def set_env_vars(app_id)
    heroku_api.put_config_vars(app_id, 'SECRET_TOKEN' => SecureRandom.hex(64))
  end

  def push_code(app_id)
    heroku_git_url = heroku_api.get_app(app_id).body["git_url"]
    Dir.mktmpdir do |dir|
      repo = Git.clone(ENV["DOLPHIN_GIT_SOURCE"], "dolphin", :path => dir)
      repo.push(heroku_git_url)
    end
  end

  def add_logger(app_id)
    heroku_api.post_addon(app_id, 'papertrail') # free papertrail
  end

end