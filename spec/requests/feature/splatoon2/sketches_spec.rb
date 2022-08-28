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

  # TODO
  describe 'POST #create' do
  end

  # TODO
  describe 'PUT #update' do
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

  # TODO
  describe 'GET monochrome_image' do
  end

  # TODO
  describe 'GET cropped_monochrome_image' do
  end
end
