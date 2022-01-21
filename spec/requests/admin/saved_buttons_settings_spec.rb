require 'rails_helper'

RSpec.describe "SavedButtonsSettings", type: :request do
  include_context "login_with_admin_user"

  describe 'GET index' do
    let(:device) { FactoryBot.create(:device) }

    it do
      get admin_saved_buttons_settings_path
      expect(response).to be_ok
    end
  end

  describe 'PUT update' do
    let(:device) { FactoryBot.create(:device) }
    let(:saved_buttons_setting) { FactoryBot.create(:saved_buttons_setting, user: admin_user) }

    subject { put admin_saved_buttons_setting_path(saved_buttons_setting), params: { name: "hoge" } }

    it do
      subject
      expect(response).to be_redirect
    end

    it do
      expect { subject }.to change { saved_buttons_setting.reload.name }
    end
  end

  describe 'DELETE destroy' do
    let(:saved_buttons_setting) { FactoryBot.create(:saved_buttons_setting, user: admin_user) }

    subject { delete admin_saved_buttons_setting_path(saved_buttons_setting); response }

    before do
      saved_buttons_setting
    end

    it { is_expected.to be_redirect }
    it { expect { subject }.to change { SavedButtonsSetting.count }.by(-1) }
  end
end
