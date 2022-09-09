require 'rails_helper'

RSpec.describe Feature::RootController, type: :request do
  describe 'GET #index' do
    subject { get feature_root_path }

    context 'ログインしているとき' do
      include_context "logged_in"

      it do
        subject
        expect(response).to be_ok
      end
    end

    context 'ログインしていないとき' do
      it do
        subject
        expect(response).to be_redirect
      end
    end
  end
end
