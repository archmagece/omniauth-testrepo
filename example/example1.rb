require "sinatra"
require_relative "oauth-commmon"
require "uri"
require "net/http"
require "json"

set :port, 3000

# 루트 경로 - 로그인 링크와 현재 상태 표시
get "/" do
  <<-HTML
  <!DOCTYPE html>
  <html>
  <head>
    <title>Kakao OAuth2 Example</title>
  </head>
  <body>
    <h1>Welcome to Kakao OAuth2 Example</h1>
    <p>
      <a href="/auth/kakao">Login with Kakao</a>
    </p>
    <h2>Current Login Status</h2>
    <p>
      Access Token: #{get_result("access_token") || "Not logged in"}
    </p>
  </body>
  </html>
  HTML
end

# 클라이언트의 인증 URL 생성
get "/auth/kakao" do
  authorize_url = @client.authorize_url(
    redirect_uri: @redirect_uri,
    client_id: ENV.fetch("KAKAO_CLIENT_ID", nil),
    response_type: "code",
    scope: "profile"
  )
  set_result("authorize_url", authorize_url)
  # redirect authorize_url
end

# OAuth2 콜백 처리
get "/callback" do
  code = params[:code]

  return "Error: Authorization code not provided." if code.nil?

  # 토큰 요청
  uri = URI("https://kauth.kakao.com/oauth/token")
  response = Net::HTTP.post_form(uri, {
                                   grant_type: "authorization_code",
                                   client_id: ENV.fetch("KAKAO_CLIENT_ID", nil),
                                   client_secret: ENV.fetch("KAKAO_CLIENT_SECRET", nil),
                                   redirect_uri: @redirect_uri,
                                   code: code
                                 })

  if response.is_a?(Net::HTTPSuccess)
    token_data = JSON.parse(response.body)
    set_result("access_token", token_data["access_token"])
    "Access Token: #{token_data["access_token"]}"
  else
    "Error: #{response.body}"
  end
end

# 결과 확인
get "/result/:key" do
  key = params[:key]
  get_result(key) || "No result for #{key}"
end
