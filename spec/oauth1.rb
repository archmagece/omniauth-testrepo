# frozen_string_literal: true

require 'faraday'
require 'oauth2'
require 'dotenv'

Dotenv.load

# 로깅 활성화
# @client = OAuth2::Client.new(
#   ENV['KAKAO_CLIENT_ID'],
#   ENV['KAKAO_CLIENT_SECRET'],
#   site: "https://kauth.kakao.com"
# ) do |builder|
#   builder.request :url_encoded
#   builder.response :logger, Logger.new(STDOUT) # 요청/응답 로깅
#   builder.adapter Faraday.default_adapter
# end
@client = OAuth2::Client.new(
  ENV['KAKAO_CLIENT_ID'],
  ENV['KAKAO_CLIENT_SECRET'],
  site: "https://kauth.kakao.com",
  options: {
    connection_build: proc do |builder|
      builder.request :url_encoded
      builder.response :logger, Logger.new(STDOUT) # 요청/응답 로깅
      builder.adapter Faraday.default_adapter
    end
  }
)

# redirect_uri = 'http://localhost:3000/auth/kakao/callback'
redirect_uri = 'http://localhost:8080/auth/realms/master/broker/kakao/endpoint'

# puts @client.authorize_url(redirect_uri: 'http://localhost:3000/callback_url')
puts @client.authorize_url(redirect_uri: redirect_uri, client_id: ENV['KAKAO_CLIENT_ID'], response_type: 'code', scope: 'profile')
# puts @client.authorize_url(redirect_uri: 'http://localhost:3000/auth/kakao/callback', client_id: ENV['KAKAO_CLIENT_ID'], response_type: 'code', scope: 'profile')

# http://localhost:3000/auth/kakao/callback?code=GUvGjgobB9UUc0CCcJET2k48V32Fpoc63qwZYeXrkqFOsE-y2hiqEQAAAAQKPCQhAAABlGkAxh6GtS2__sNdBQ
# http://localhost:8080/auth/realms/master/broker/kakao/endpoint?code=Sx6D5QhOJWVEVIIkBEbu4p5zSXJDasc9F2Y3bBfS4_xSsBQTiJYk3wAAAAQKKiURAAABlGkP9PDo6jj-qNQmaA
# http://localhost:8080/auth/realms/master/broker/kakao/endpoint?code=2L3BjJ1ly8aHImX6nG-Em7YtSlUHcl3njzjnPi7fWLcEJdYafKEhngAAAAQKKwyoAAABlGkdND4WphHJzwXJqw
verifier = '2L3BjJ1ly8aHImX6nG-Em7YtSlUHcl3njzjnPi7fWLcEJdYafKEhngAAAAQKKwyoAAABlGkdND4WphHJzwXJqw'
token = @client.get_token({
                            client_id: @client.id,
                            grant_type: 'authorization_code',
                            code: verifier,
                            redirect_uri: redirect_uri,
                          })
puts token
