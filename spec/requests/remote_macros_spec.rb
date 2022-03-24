require 'rails_helper'

RSpec.describe RemoteMacrosController, type: :request do
  include_context "login_with_user"

  describe "GET #new" do
    let(:remote_macro_group) { FactoryBot.create(:remote_macro_group, user: user) }

    subject { get new_remote_macro_group_remote_macro_path(remote_macro_group) }

    it do
      subject
      expect(response).to be_ok
    end
  end

  describe "POST #create" do
    let(:remote_macro_group) { FactoryBot.create(:remote_macro_group, user: user) }

    subject { post remote_macro_group_remote_macros_path(remote_macro_group), params: { remote_macro: { name: "foo", steps: "x" } } }

    it do
      subject
      expect(response).to be_redirect
    end

    it do
      expect { subject }.to change { user.remote_macros.count }.by(1)
    end
  end

  describe "DELETE #destroy" do
    let(:remote_macro_group) { FactoryBot.create(:remote_macro_group, user: user) }
    let(:remote_macro) { FactoryBot.create(:remote_macro, remote_macro_group: remote_macro_group, steps: "") }

    subject { delete remote_macro_path(remote_macro) }

    before do
      remote_macro
    end

    it do
      subject
      expect(response).to be_redirect
    end

    it do
      expect { subject }.to change { user.remote_macros.count }.by(-1)
    end
  end

  describe 'POST #test_emit' do
    let(:remote_macro_group) { FactoryBot.create(:remote_macro_group, user: user) }
    let(:remote_macro) { FactoryBot.create(:remote_macro, remote_macro_group: remote_macro_group, steps: "") }
    let(:device) { FactoryBot.create(:device, user: user) }

    subject { post remote_macro_test_emit_path(remote_macro, device.unique_key) }

    it do
      subject
      expect(response).to be_redirect
    end

    it do
      expect { subject }.to change { device.pbm_remote_macro_jobs.count }.by(1)
    end

    it do
      expect { subject }.to have_broadcasted_to(device.push_token)
    end
  end

  describe 'GET #edit_trigger_words' do
    let(:remote_macro_group) { FactoryBot.create(:remote_macro_group, user: user) }
    let(:remote_macro) { FactoryBot.create(:remote_macro, remote_macro_group: remote_macro_group, steps: "") }
    let(:device) { FactoryBot.create(:device, user: user) }

    subject { get edit_trigger_words_remote_macro_path(remote_macro, device.unique_key) }

    it do
      subject
      expect(response).to be_ok
    end
  end

  describe 'PATCH #update_trigger_words' do
    let(:remote_macro_group) { FactoryBot.create(:remote_macro_group, user: user) }
    let(:remote_macro) { FactoryBot.create(:remote_macro, remote_macro_group: remote_macro_group, steps: "") }
    let(:device) { FactoryBot.create(:device, user: user) }

    subject { patch update_trigger_words_remote_macro_path(remote_macro, device.unique_key), params: { remote_macro: { trigger_word_list: "foo" } } }

    it do
      subject
      expect(response).to be_redirect
    end

    it do
      expect { subject }.to change { remote_macro.reload.trigger_word_list }.from([]).to(["foo"])
    end
  end
end
