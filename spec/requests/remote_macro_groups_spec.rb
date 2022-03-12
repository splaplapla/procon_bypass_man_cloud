require 'rails_helper'

RSpec.describe RemoteMacroGroupsController, type: :request do
  include_context "login_with_user"

  describe "GET #index" do
    let(:remote_macro_group) { FactoryBot.create(:remote_macro_group, user: user) }

    subject { get remote_macro_groups_path }

    before do
      remote_macro_group
    end

    it do
      subject
      expect(response).to be_ok
    end
  end

  describe "GET #new" do
    subject { get new_remote_macro_group_path }

    it do
      subject
      expect(response).to be_ok
    end
  end

  describe "POST #create" do
    subject { post remote_macro_groups_path, params: { remote_macro_group: { name: "foo" } } }

    it do
      subject
      expect(response).to be_redirect
    end

    it do
      expect { subject }.to change { user.remote_macro_groups.count }.by(1)
    end
  end

  describe "GET #show" do
    let(:remote_macro_group) { FactoryBot.create(:remote_macro_group, user: user) }
    let(:remote_macro) { FactoryBot.create(:remote_macro, remote_macro_group: remote_macro_group, steps: "") }
    let(:device) { FactoryBot.create(:device, user: user) }

    before do
      remote_macro
      device
    end

    it do
      get remote_macro_group_path(remote_macro_group)
      expect(response).to be_ok
    end
  end

  describe "DELETE #destroy" do
    let(:remote_macro_group) { FactoryBot.create(:remote_macro_group, user: user) }

    subject { delete remote_macro_group_path(remote_macro_group) }

    before do
      remote_macro_group
    end

    it do
      subject
      expect(response).to be_redirect
    end

    it do
      expect { subject }.to change { user.remote_macro_groups.count }.by(-1)
    end
  end
end
