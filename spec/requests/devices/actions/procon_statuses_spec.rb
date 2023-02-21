require 'rails_helper'

RSpec.describe 'Devices::Actions::ProconStatuses', type: :request do
  describe "POST #create" do
    include_context "login_with_user"

    let(:device) { FactoryBot.create(:device, user: user) }

    subject { post device_actions_procon_status_path(device.unique_key, format: :js) }

    it do
      subject
      expect(response).to be_ok
    end

    it do
      subject
      pbm_job = device.pbm_jobs.last
      expect(pbm_job.action).to eq("report_porcon_status")
    end
  end
end
