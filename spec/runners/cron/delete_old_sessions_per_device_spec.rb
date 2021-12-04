require 'rails_helper'

RSpec.describe Cron::DeleteOldSessionsPerDevice do
  let(:device) { Device.create(uuid: :a, hostname: "aa") }
  let(:pbm_session) { PbmSession.create(uuid: :a, device: device, hostname: "a", created_at: 7.days.ago) }

  before do
    pbm_session
  end

  it do
    expect { described_class.execute!  }.to change { PbmSession.count }.by(-1)
  end
end
