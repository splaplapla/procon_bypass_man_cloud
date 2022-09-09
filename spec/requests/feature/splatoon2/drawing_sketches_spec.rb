require 'rails_helper'

describe Feature::Splatoon2::DrawingSketchesController, type: :request do
  include_context "login_with_user"

  describe 'GET #show' do
    let(:device) {FactoryBot.create(:device, user: user) }
    let(:splatoon2_sketch) { FactoryBot.create(:splatoon2_sketch, :has_image, user: user) }

    subject { get feature_splatoon2_sketch_device_drawing_sketch_path(splatoon2_sketch.id, device.unique_key) }

    it do
      subject
      expect(response).to be_ok
    end
  end

  describe 'POST #create' do
    subject { post feature_splatoon2_sketch_device_drawing_sketch_path(splatoon2_sketch.id, device.unique_key), params: drawing_params }

    context 'when macros provides ""' do
      let(:drawing_params) { { macros: "" } }
      let(:device) {FactoryBot.create(:device, user: user) }
      let(:splatoon2_sketch) { FactoryBot.create(:splatoon2_sketch, :has_image, user: user) }

      it do
        subject
        expect(response).to be_bad_request
      end

      it do
        expect { subject }.not_to change { device.pbm_remote_macro_jobs.count }
      end

      it do
        expect { subject }.not_to have_broadcasted_to(device.push_token)
      end
    end

    context 'when macros provides nil' do
      let(:drawing_params) { { macros: nil } }
      let(:device) {FactoryBot.create(:device, user: user) }
      let(:splatoon2_sketch) { FactoryBot.create(:splatoon2_sketch, :has_image, user: user) }

      it do
        subject
        expect(response).to be_bad_request
      end

      it do
        expect { subject }.not_to change { device.pbm_remote_macro_jobs.count }
      end

      it do
        expect { subject }.not_to have_broadcasted_to(device.push_token)
      end
    end

    context 'when macros provides []' do
      let(:drawing_params) { { macros: [] } }
      let(:device) {FactoryBot.create(:device, user: user) }
      let(:splatoon2_sketch) { FactoryBot.create(:splatoon2_sketch, :has_image, user: user) }

      it do
        subject
        expect(response).to be_bad_request
      end

      it do
        expect { subject }.not_to change { device.pbm_remote_macro_jobs.count }
      end

      it do
        expect { subject }.not_to have_broadcasted_to(device.push_token)
      end
    end

    context 'when macros provides [value]' do
      let(:drawing_params) { { macros: [:a] } }
      let(:device) {FactoryBot.create(:device, user: user) }
      let(:splatoon2_sketch) { FactoryBot.create(:splatoon2_sketch, :has_image, user: user) }

      it do
        subject
        expect(response).to be_ok
      end

      it do
        expect { subject }.to change { device.pbm_remote_macro_jobs.count }.by(1)
      end

      it do
        expect { subject }.to have_broadcasted_to(device.push_token)
      end
    end
  end
end
