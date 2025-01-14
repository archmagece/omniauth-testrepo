# Sb::Omniauth::Kakao

## Installation

```ruby
gem 'sb-omniauth-kakao', git: 'https://github.com/ScriptonBasestar/sb-omniauth-kakao'
```

## Kakao app
https://developers.kakao.com/console/app

## Usage

```ruby
# devise.rb
Rails.application.config.middleware.use OmniAuth::Builder do
  require 'omniauth/strategies/kakao'
  config.omniauth :kakao, ENV["kakao_client_key"], ENV["kakao_client_secret"], redirect_url: ENV["kakao_redirect_uri"], scope: ENV['kakao_scope'], :strategy_class => OmniAuth::Strategies::KakaoOauth2
end
OmniAuth.config.allowed_request_methods = %i[get]
```

```ruby
# application.yml
kakao_client_key: aaaa
kakao_client_secret: aaaa
kakao_scope: profile
# kakao_redirect_uri: /users/auth/kakao/callback
kakao_redirect_uri: http://localhost:3000/users/auth/kakao/callback
```
