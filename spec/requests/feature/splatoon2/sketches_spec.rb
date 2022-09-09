require 'rails_helper'

RSpec.describe Feature::Splatoon2::SketchesController, type: :request do
  describe 'GET #index' do
    include_context "login_with_user"

    subject { get feature_splatoon2_sketches_path }

    it do
      subject
      expect(response).to be_ok
    end

    context 'スケッチを持っている' do
      let(:splatoon2_sketch) { FactoryBot.create(:splatoon2_sketch, user: user) }

      before { splatoon2_sketch }

      it do
        subject
        expect(response).to be_ok
      end
    end
  end

  describe 'GET #new' do
    include_context "login_with_user"

    subject { get new_feature_splatoon2_sketch_path }

    it do
      subject
      expect(response).to be_ok
    end

    context 'プランの上限を超えているとき' do
      before do
        2.times { FactoryBot.create(:splatoon2_sketch, user: user) } # free user
      end

      it do
        subject
        expect(response).to be_redirect
      end
    end
  end

  describe 'POST #create' do
    include_context "login_with_user"

    let(:splatoon2_sketch_params) do
      { splatoon2_sketch: { name: "a",
                            image: fixture_file_upload(File.join(Rails.root, "spec", "files", "dummy.gif")),
        },
      }
    end

    subject { post feature_splatoon2_sketches_path, params: splatoon2_sketch_params }

    it { expect { subject }.to change { user.splatoon2_sketches.count }.by(1) }
    it do
      subject
      expect(response).to be_redirect
    end
  end

  describe 'PUT #update' do
    include_context "login_with_user"

    let(:splatoon2_sketch) { FactoryBot.create(:splatoon2_sketch, user: user) }
    let(:splatoon2_sketch_params) do
      { splatoon2_sketch: {
        crop_data: { a: 1 } }
      }
    end

    subject { put feature_splatoon2_sketch_path(splatoon2_sketch.id), params: splatoon2_sketch_params }

    it do
      subject
      expect(response).to be_redirect
    end
  end

  describe 'GET #edit' do
    include_context "login_with_user"

    let(:splatoon2_sketch) { FactoryBot.create(:splatoon2_sketch, user: user) }

    subject { get edit_feature_splatoon2_sketch_path(splatoon2_sketch) }

    it do
      subject
      expect(response).to be_ok
    end
  end


  describe 'GET #edit_binary_threshold' do
    include_context "login_with_user"

    let(:splatoon2_sketch) { FactoryBot.create(:splatoon2_sketch, user: user) }

    subject { get edit_binary_threshold_feature_splatoon2_sketch_path(splatoon2_sketch) }

    it do
      subject
      expect(response).to be_ok
    end
  end

  describe 'DELETE #destroy' do
    include_context "login_with_user"

    let(:splatoon2_sketch) { FactoryBot.create(:splatoon2_sketch, user: user) }

    subject { delete feature_splatoon2_sketch_path(splatoon2_sketch) }

    it do
      subject
      expect(response).to be_redirect
    end

    it do
      expect { subject }.to change { Splatoon2Sketch.exists?(id: splatoon2_sketch) }.to(false)
    end
  end

  describe 'GET monochrome_image' do
    include_context "login_with_user"

    let(:splatoon2_sketch) { FactoryBot.create(:splatoon2_sketch, :has_image, user: user) }

    subject { get cropped_monochrome_image_feature_splatoon2_sketch_path(splatoon2_sketch.id) }

    it do
      subject
      expect(response).to be_ok
    end
  end

  describe 'GET cropped_monochrome_image' do
    include_context "login_with_user"

    let(:splatoon2_sketch) { FactoryBot.create(:splatoon2_sketch, :has_image, user: user) }

    subject { get cropped_monochrome_image_feature_splatoon2_sketch_path(splatoon2_sketch.id) }

    it do
      subject
      expect(response).to be_ok
    end
  end
end
