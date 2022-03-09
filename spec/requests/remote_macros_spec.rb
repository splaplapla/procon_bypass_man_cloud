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
end
