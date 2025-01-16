require "sinatra/base"
require "logger"

class App < Sinatra::Base
  configure do
    # 로깅 설정
    $logger = Logger.new(STDOUT)
    $logger.level = Logger::DEBUG

    # Sinatra 로깅 활성화
    enable :logging
    set :logger, $logger

    enable :sessions
    set :session_secret, ENV.fetch("RACK_COOKIE_SECRET", "a3f5e6d7c8b9a0b1c2d3e4f5a6b7c8d9e0f1a2b3c4d5e6f7a8b9c0d1e2f3a4b5")
  end

  before do
    env["rack.logger"] = settings.logger
  end

  get "/" do
    logger.info "GET / accessed INFO"
    logger.debug "Hello, world! DEBUG"
    "Hello, world!"
  end
end

# Rack::CommonLogger를 사용해 모든 요청 로깅
use Rack::CommonLogger, $logger

run App.new
