require 'rails_helper'

describe PbmRemoteMacroJobSerializer do
  describe "#attributes" do
    let(:device) { FactoryBot.create(:device) }
    let(:remote_macro_job) { RemoteMacro::CreatePbmRemoteMacroJobService.new(device: device).execute(steps: [:a], name: "foo") }

    it do
      expect(described_class.new(remote_macro_job).attributes).to eq(
        action: "remote_macro", name: "foo", uuid: remote_macro_job.uuid, steps: ["a"], created_at: remote_macro_job.created_at
      )

    end
  end
end
