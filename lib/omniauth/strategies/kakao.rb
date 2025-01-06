# frozen_string_literal: true

require 'jwt'
require 'oauth2'
require 'omniauth/strategies/oauth2'
require 'uri'

module OmniAuth
  module Strategies
    class KakaoOauth2 < OmniAuth::Strategies::OAuth2
      ALLOWED_ISSUERS = ['kauth.kakao.com', 'https://kauth.kakao.com'].freeze
      # BASE_SCOPE_URL = 'https://kauth.kakao.com/oauth/authorize/'
      BASE_SCOPES = %w[profile account_email openid].freeze
      DEFAULT_SCOPE = 'account_email,profile'
      IMAGE_SIZE_REGEXP = /(s\d+(-c)?)|(w\d+-h\d+(-c)?)|(w\d+(-c)?)|(h\d+(-c)?)|c/
      AUTHORIZE_OPTIONS = %i[access_type hd login_hint prompt request_visible_actions scope state redirect_uri include_granted_scopes enable_granular_consent openid_realm device_id device_name]

      BASE_URL = 'https://kauth.kakao.com'
      AUTHORIZE_URL = '/oauth/authorize'
      AUTHORIZE_TOKEN_URL = '/oauth/token'
      TOKEN_INFO_URL = '/oauth/tokeninfo'

      OPENID_CONFIG_URL = 'https://kauth.kakao.com/.well-known/openid-configuration'

      # https://kapi.kakao.com/v2/user/me
      # USER_INFO_URL = 'v1/oidc/userinfo'
      USER_INFO_URL = '/v2/user/me'

      option :name, 'kakao'
      option :client_options,
             site: BASE_URL,
             authorize_url: AUTHORIZE_URL,
             token_url: AUTHORIZE_TOKEN_URL
      uid { raw_info['id'].to_s }

      info do
        {
          name: raw_info['name'],
          username: raw_info['username'],
          email: raw_info['email'],
          image: raw_info['avatar_url']
        }
      end

      extra do
        { raw_info: raw_info }
      end

      def raw_info
        @raw_info ||= access_token.get(USER_INFO_URL).parsed
      end

      def callback_url
        options.redirect_url || (full_host + callback_path)
      end
    end
  end
end

OmniAuth.config.add_camelization 'kakao', 'Kakao'
