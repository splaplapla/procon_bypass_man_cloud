require 'rails_helper'

describe RemoteMacro::CreatePbmRemoteMacroJobService do
  let(:device) { FactoryBot.create(:device) }

  describe '#execute' do
    context do
      subject { described_class.new(device: device).execute(name: "foo", steps: "foo") }

      it do
        expect { subject }.to change { device.pbm_remote_macro_jobs.count }.by(1)
      end

      it do
        expect(subject).to be_truthy
      end

      it do
        expect(subject.steps).to eq(["foo"])
      end
    end

    context 'stepsがカンマ区切りとスペース入り' do
      subject { described_class.new(device: device).execute(name: "foo", steps: "foo, toggle, foo") }

      it do
        expect { subject }.to change { device.pbm_remote_macro_jobs.count }.by(1)
      end

      it do
        expect(subject.steps).to eq(["foo", "toggle", "foo"])
      end
    end

    context 'stepsがカンマ区切り' do
      subject { described_class.new(device: device).execute(name: "foo", steps: "foo,toggle,foo") }

      it do
        expect { subject }.to change { device.pbm_remote_macro_jobs.count }.by(1)
      end

      it do
        expect(subject.steps).to eq(["foo", "toggle", "foo"])
      end
    end
  end
end
