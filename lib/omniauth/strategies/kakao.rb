# frozen_string_literal: true

require "omniauth-oauth2"

module OmniAuth
  module Strategies
    class Kakao < OmniAuth::Strategies::OAuth2
      # ALLOWED_ISSUERS = %w[kauth.kakao.com https://kauth.kakao.com].freeze
      # BASE_SCOPE_URL = 'https://kauth.kakao.com/oauth/authorize/'
      # BASE_SCOPES = %w[profile account_email openid].freeze
      DEFAULT_SCOPE = "account_email,profile".freeze
      # IMAGE_SIZE_REGEXP = /(s\d+(-c)?)|(w\d+-h\d+(-c)?)|(w\d+(-c)?)|(h\d+(-c)?)|c/
      # AUTHORIZE_OPTIONS = %i[access_type hd login_hint prompt request_visible_actions scope state redirect_uri include_granted_scopes enable_granular_consent openid_realm device_id device_name]

      BASE_URL = "https://kauth.kakao.com".freeze
      AUTHORIZE_URL = "/oauth/authorize".freeze
      AUTHORIZE_TOKEN_URL = "/oauth/token".freeze
      TOKEN_INFO_URL = "/oauth/tokeninfo".freeze

      OPENID_CONFIG_URL = "https://kauth.kakao.com/.well-known/openid-configuration".freeze

      # https://kapi.kakao.com/v2/user/me
      # USER_INFO_URL = 'v1/oidc/userinfo'
      USER_INFO_URL = "https://kapi.kakao.com/v2/user/me".freeze
      # USER_INFO_URL = "kapi.kakao.com/v2/user/me"

      option :client_options,
             site: BASE_URL,
             authorize_url: AUTHORIZE_URL,
             token_url: AUTHORIZE_TOKEN_URL

      uid { raw_info["id"].to_s }

      info do
        hash = {
          name: raw_info["properties"]["nickname"],
          username: raw_info["kakao_account"]["email"],
          image: raw_info["properties"]["thumbnail_image"]
        }
        if raw_info["kakao_account"]["has_email"] && raw_info["kakao_account"]["is_email_verified"] && raw_info["kakao_account"]["is_email_valid"]
          hash[:email] = raw_info["kakao_account"]["email"]
        end
        raw_info
      end

      extra do
        { raw_info: raw_info }
      end

      def callback_url
        # puts "auth_token_params >>>>>>>>>>"
        # puts "redirect_url #{options.redirect_url}"
        # puts "full_host #{full_host}"
        # puts "callback_path #{callback_path}"
        # puts "auth_token_params ----------" 
        options.redirect_url || (full_host + callback_path)
      end

      # def authorize_params
      #   options.authorize_params[:state] = SecureRandom.hex(24)
      #
      #   if OmniAuth.config.test_mode
      #     @env ||= {}
      #     @env["rack.session"] ||= {}
      #   end
      #
      #   params = options.authorize_params
      #                   .merge(options_for("authorize"))
      #                   .merge(pkce_authorize_params)
      #
      #   params[:client_id] = options.client_id  # client_id 추가
      #
      #   session["omniauth.pkce.verifier"] = options.pkce_verifier if options.pkce
      #   session["omniauth.state"] = params[:state]
      #
      #   params
      # end

      def auth_token_params
        puts "auth_token_params >>>>>>>>>>"
        puts "client_id", options.client_id
        # puts token_params
        verifier = session.delete("omniauth.pkce.verifier")
        params = {
          code: request.params["code"],
          client_id: options.client_id,
          client_secret: options.client_secret,
          redirect_uri: callback_url,
          grant_type: "authorization_code"
        }
        params[:code_verifier] = verifier if verifier
        puts "auth_token_params <<<<<<<<<<"
        params
      end

      # def token_params
      #   # options.token_params.merge(options_for("token")).merge(pkce_token_params)
      #   options.token_params.merge(options_for("token")).merge(pkce_token_params).merge(client_id: options.client_id)
      # end

      def build_access_token
        puts 'build_access_token >>>>>>>>>>'
        verifier = request.params["code"]
        puts verifier
        # token = client.auth_code.get_token(verifier, { redirect_uri: callback_url }.merge(token_params.to_hash(symbolize_keys: true)), deep_symbolize(options.auth_token_params))
        # puts options
        puts client.options
        puts '========================='
        token = client.auth_code.get_token(verifier, {
          redirect_uri: callback_url,
          client_id: options.client_id,
          # client_secret: options.client_secret
        }.merge(token_params.to_hash(symbolize_keys: true)), deep_symbolize(options.auth_token_params))
        puts "print token : #{token}"
        puts 'build_access_token <<<<<<<<<<'
        token
      end

      private

      def raw_info
        @raw_info ||= access_token.get(USER_INFO_URL).parsed
      end
    end
  end
end

OmniAuth.config.add_camelization "kakao", "Kakao"
