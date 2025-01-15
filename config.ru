# frozen_string_literal: true

# Sample app for Google OAuth2 Strategy
# Make sure to setup the ENV variables GOOGLE_KEY and GOOGLE_SECRET
# Run with "bundle exec rackup"

require "rubygems"
require "bundler"
require "sinatra"
require "omniauth"
require "faraday"
# require "sb-omniauth-kakao"
# require_relative "../lib/sb-omniauth-kakao.rb"
require "./lib/sb-omniauth-kakao"

require "dotenv"
Dotenv.load

# Do not use for production code.
# This is only to make setup easier when running through the sample.
#
# If you do have issues with certs in production code, this could help:
# http://railsapps.github.io/openssl-certificate-verify-failed.html
# OpenSSL::SSL::VERIFY_PEER = OpenSSL::SSL::VERIFY_NONE

class App < Sinatra::Base
  configure do
    set :sessions, true
    set :inline_templates, true
  end

  use Rack::Session::Cookie, secret: ENV.fetch("RACK_COOKIE_SECRET", "a3f5e6d7c8b9a0b1c2d3e4f5a6b7c8d9e0f1a2b3c4d5e6f7a8b9c0d1e2f3a4b5")

  use OmniAuth::Builder do
    # provider :kakao, ENV.fetch("KAKAO_CLIENT_ID", nil), ENV.fetch("KAKAO_CLIENT_SECRET", nil), access_type: "offline", prompt: "consent", provider_ignores_state: true, scope: "account_email,profile", :strategy_class => OmniAuth::Strategies::KakaoOauth2
    provider :kakao, ENV.fetch("KAKAO_CLIENT_ID", nil), ENV.fetch("KAKAO_CLIENT_SECRET", nil),
             scope: ENV.fetch("KAKAO_CLIENT_SCOPE", "profile"),
             client_options: {
               connection_build: lambda do |builder|
                 builder.request :url_encoded
                 #  builder.response :logger, $logger
                 #  builder.adapter Faraday.default_adapter
               end
             }
    before_callback_phase do |_env|
      puts "before_callback_phase"
      # puts env
    end
    puts "OmniAuth::Strategies::KakaoOauth2"
    puts "KAKAO_CLIENT_ID: #{ENV.fetch("KAKAO_CLIENT_ID", nil)}"
    puts "KAKAO_CLIENT_SECRET: #{ENV.fetch("KAKAO_CLIENT_SECRET", nil)}"
  end
  OmniAuth.config.on_failure = proc do |env|
    error = env["omniauth.error"]
    puts "OmniAuth error: #{error.inspect}"
    OmniAuth::FailureEndpoint.new(env).redirect_to_failure
  end

  get "/" do
    logger.info "========================================================"
    logger.debug "========================================================"
    logger.info "route GET /"
    <<-HTML
    <!DOCTYPE html>
    <html>
      <head>
        <title>Kakao OAuth2 Example</title>
        <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.2.1/jquery.min.js"></script>
        <script>
          jQuery(function() {
            return $.ajax({
              url: 'https://apis.google.com/js/client:plus.js?onload=gpAsyncInit',
              dataType: 'script',
              cache: true
            });
          });

          window.gpAsyncInit = function() {
            gapi.auth.authorize({
              immediate: true,
              response_type: 'code',
              cookie_policy: 'single_host_origin',
              client_id: "#{ENV.fetch("KAKAO_CLIENT_ID", nil)}",
              scope: 'account_email profile'
            }, function(response) {
              return;
            });
            $('.kakao-login').click(function(e) {
              e.preventDefault();
              gapi.auth.authorize({
                immediate: false,
                response_type: 'code',
                cookie_policy: 'single_host_origin',
                client_id: "#{ENV.fetch("KAKAO_CLIENT_ID", nil)}",
                # scope: 'account_email profile'
                scope: 'profile'
              }, function(response) {
                if (response && !response.error) {
                  // kakao authentication succeed, now post data to server.
                  jQuery.ajax({type: 'POST', url: "/auth/kakao/callback", data: response,
                    success: function(data) {
                      // Log the data returning from kakao.
                      console.log(data)
                    }
                  });
                } else {
                  // kakao authentication failed.
                  console.log("FAILED")
                }
              });
            });
          };
        </script>
      </head>
      <body>
      <ul>
        <li>
          <form method='post' action='/auth/kakao'>
            <input type="hidden" name="authenticity_token" value="#{request.env["rack.session"]["csrf"]}">
            <button type='submit'>Login with Kakao</button>
          </form>
        </li>
        <li><a href='#' class="kakao-login">Sign in with Kakao via AJAX</a></li>
      </ul>
      </body>
    </html>
    HTML
  end

  post "/auth/:provider/callback" do
    logger.info "========================================================"
    logger.info "route POST /auth/:provider/callback"
    content_type "text/plain"
    begin
      logger.info "begin"
      logger.info request.env["omniauth.auth"]
      logger.info request.env["omniauth.auth"].to_hash
      request.env["omniauth.auth"].to_hash.inspect
    rescue StandardError
      "No Data"
    end
  end

  get "/auth/:provider/callback" do
    logger.info "========================================================"
    logger.info "route GET /auth/:provider/callback"
    content_type "text/plain"
    begin
      logger.info "begin"
      logger.info request.env["omniauth.auth"]
      logger.info request.env["omniauth.auth"].to_hash
      request.env["omniauth.auth"].to_hash.inspect
    rescue StandardError
      "No Data"
    end
  end

  get "/auth/failure" do
    logger.info "========================================================"
    logger.info "route GET /auth/failure"
    begin
      logger.info "begin"
      logger.info request.env["omniauth.auth"]
      logger.info request.env["omniauth.auth"].to_hash
      request.env["omniauth.auth"].to_hash.inspect
    rescue StandardError
      <<-HTML
      <!DOCTYPE html>
      <html>
        <head>
          <title>Kakao OAuth2 Example</title>
        </head>
        <body>
          <h1>No Data</h1>
          <p>Request Params: #{request.params.inspect}</p>
        </body>
      </html>
      HTML
    end
  end
end

run App.new
