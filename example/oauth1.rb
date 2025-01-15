# frozen_string_literal: true

require_relative "oauth-commmon"

# puts @client.authorize_url(redirect_uri: 'http://localhost:3000/callback_url')
authorize_url = @client.authorize_url(redirect_uri: @redirect_uri, client_id: ENV.fetch("KAKAO_CLIENT_ID", nil), response_type: "code", scope: "profile")
# puts @client.authorize_url(redirect_uri: 'http://localhost:3000/auth/kakao/callback', client_id: ENV['KAKAO_CLIENT_ID'], response_type: 'code', scope: 'profile')

set_result("authorize_url", authorize_url)

require "sinatra"
require "uri"
require "net/http"
require "json"

set :port, 3000

get '/auth/kakao'