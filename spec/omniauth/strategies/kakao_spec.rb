# frozen_string_literal: true

require 'spec_helper'
require 'json'
require 'stringio'

RSpec.describe OmniAuth::Strategies::Kakao do
  let(:access_token) { double('AccessToken') }
  let(:parsed_response) { double('ParsedResponse') }
  let(:response) { double('Response', parsed: parsed_response) }

  let(:enterprise_site) { 'https://some.other.site.com' }

  let(:kakao_service) { OmniAuth::Strategies::KakaoOauth2.new({}) }
  let(:enterprise) do
    OmniAuth::Strategies::Kakao.new(
      "kakao",
      'KAKAO_CLIENT_KEY', 'KAKAO_CLIENT_SECRET',
      client_options: { site: enterprise_site },
      redirect_url: 'http://localhost:9292/callback_url'
    )
  end

  subject { kakao_service }

  before(:each) do
    allow(subject).to receive(:access_token).and_return(access_token)
  end

  describe 'client options' do
    context 'with defaults' do
      subject { kakao_service.options.client_options }

      its(:site) { is_expected.to eq 'https://kauth.kakao.com' }
    end

    context 'with override' do
      subject { enterprise.options.client_options }

      its(:site) { is_expected.to eq enterprise_site }
    end
  end

  describe 'redirect_url' do
    context 'with defaults' do
      subject { kakao_service.options }
      its(:redirect_url) { is_expected.to be_nil }
    end

    context 'with customs' do
      subject { enterprise.options }
      its(:redirect_url) { is_expected.to eq 'http://localhost:9292/callback_url' }
    end
  end

  describe '#raw_info' do
    it 'sent request to current user endpoint' do
      expect(access_token).to receive(:get).with('/v2/user/me').and_return(response)
      expect(subject.raw_info).to eq(parsed_response)
    end
  end

  describe '#callback_url' do
    let(:base_url) { 'https://example.com' }

    context 'no script name present' do
      it 'has the correct default callback path' do
        allow(subject).to receive(:full_host) { base_url }
        allow(subject).to receive(:script_name) { '' }
        allow(subject).to receive(:query_string) { '' }
        expect(subject.callback_url).to eq(base_url + '/auth/kakao/callback')
      end
    end

    context 'script name' do
      it 'should set the callback path with script_name' do
        allow(subject).to receive(:full_host) { base_url }
        allow(subject).to receive(:script_name) { '/v1' }
        allow(subject).to receive(:query_string) { '' }
        expect(subject.callback_url).to eq(base_url + '/v1/auth/kakao/callback')
      end
    end
  end
end