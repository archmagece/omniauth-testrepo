# frozen_string_literal: true

require "faraday"
require "oauth2"
require "dotenv"
require "yaml"

Dotenv.load

# 로깅 활성화
@client = OAuth2::Client.new(
  ENV.fetch("KAKAO_CLIENT_ID", nil),
  ENV.fetch("KAKAO_CLIENT_SECRET", nil),
  site: "https://kauth.kakao.com"
) do |builder|
  builder.request :url_encoded
  builder.response :logger, Logger.new(STDOUT),  { headers: true, bodies: { request: false, response: true }, errors: true }
  builder.adapter Faraday.default_adapter
end
# @client = OAuth2::Client.new(
#   ENV.fetch("KAKAO_CLIENT_ID", nil),
#   ENV.fetch("KAKAO_CLIENT_SECRET", nil),
#   site: "https://kauth.kakao.com",
#   options: {
#     connection_build: proc do |builder|
#       builder.request :url_encoded
#       builder.response :logger, Logger.new(STDOUT) # 요청/응답 로깅
#       builder.adapter Faraday.default_adapter
#     end
#   }
# )

# @redirect_uri = 'http://localhost:3000/auth/kakao/callback'
@redirect_uri = "http://localhost:8080/auth/realms/master/broker/kakao/endpoint"

def get_result(key)
  data = YAML.load_file("tmp-oauth-results.yaml")
  data["results"].key?(key) ? data["results"][key] : nil
rescue StandardError
  nil
end

def set_result(key, val)
  data = YAML.load_file("tmp-oauth-results.yaml")
  data["results"][key] = val
  File.write("tmp-oauth-results.yaml", data.to_yaml)
end

def exists_result?(key)
  data = YAML.load_file("tmp-oauth-results.yaml")
  data["results"].key?(key)
end
