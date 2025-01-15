# frozen_string_literal: true

# frozen_string_literal: true

require 'spec_helper'
require 'json'
require 'stringio'
require 'faraday'

RSpec.describe OmniAuth::Strategies::Kakao do
  let(:access_token) { double('AccessToken') }
  let(:parsed_response) { double('ParsedResponse') }
  let(:response) { double('Response', parsed: parsed_response) }

  let(:kakao_strategy) do
    OmniAuth::Strategies::Kakao.new(
      "kakao",
      'KAKAO_CLIENT_KEY', 'KAKAO_CLIENT_SECRET',
      client_options: { site: enterprise_site },
      redirect_url: 'http://localhost:9292/callback_url'
    )

    let(:oauth_client) do
      OAuth2::Client.new(
        ENV['KAKAO_CLIENT_ID'],
        ENV['KAKAO_CLIENT_SECRET'],
        site: "https://kauth.kakao.com"
      ) do |builder|
        builder.request :url_encoded
        builder.response :logger, Logger.new(STDOUT) # 요청/응답 로깅
        builder.adapter Faraday.default_adapter
      end
    end
  end

  subject { kakao_strategy }

  before(:each) do
    allow(subject).to receive(:access_token).and_return(access_token)
  end

  describe 'oauth login test' do
    context 'generate authorization url' do
      subject { kakao_service.options.client_options }



      its(:site) { is_expected.to eq 'https://kauth.kakao.com' }
    end

    context 'with override' do
      subject { enterprise.options.client_options }

      its(:site) { is_expected.to eq enterprise_site }
    end
  end
end