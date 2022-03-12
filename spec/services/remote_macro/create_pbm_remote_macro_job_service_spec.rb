require 'rails_helper'

describe RemoteMacro::CreatePbmRemoteMacroJobService do
  let(:device) { FactoryBot.create(:device) }

  describe '#execute' do
    subject { described_class.new(device: device).execute(name: "foo", steps: "foo") }

    it do
      expect { subject }.to change { device.pbm_remote_macro_jobs.count }.by(1)
    end

    it do
      expect(subject).to be_truthy
    end
  end
end
