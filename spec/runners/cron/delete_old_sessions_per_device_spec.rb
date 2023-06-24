require 'rails_helper'

RSpec.describe Cron::DeleteOldSessionsPerDevice do
  let(:device) { FactoryBot.create(:device) }
  let(:old_pbm_session) { PbmSession.create(uuid: :a, device: device, hostname: "a", updated_at: 7.days.ago) }
  let(:active_pbm_session) { PbmSession.create(uuid: :a2, device: device, hostname: "a2") }

  subject { described_class.execute! }

  before do
    old_pbm_session
    active_pbm_session
  end

  it { expect { subject }.to change { PbmSession.count }.by(-1) }
  it { expect { subject }.not_to(change { active_pbm_session.reload }) }
end
