require 'rails_helper'

RSpec.describe Splatoon2Sketch, type: :model do
  let(:user) { FactoryBot.create(:user) }

  describe '#validate' do
    describe '#validate_image_extension' do
      let(:file) { Rack::Test::UploadedFile.new(File.join(Rails.root, 'spec', 'files', 'dummy.gif'), "image/gif:web") }
      let(:sketch) { user.splatoon2_sketches.build(name: 'hoge', image: file) }

      it do
        sketch.valid?
        expect(sketch.errors[:encoded_image]).to eq(["はgifに対応していません。"])
      end
    end
  end

  describe '#encoded_image' do
    let(:file) { Rack::Test::UploadedFile.new(File.join(Rails.root, 'spec', 'files', 't.jpeg'), "image/jpeg") }
    let(:sketch) { user.splatoon2_sketches.create!(name: 'hoge', image: file) }

    it do
      expect(sketch.encoded_image).to start_with('image/jpeg;base64,')
    end
  end

  describe '#decode_image' do
    let(:file) { Rack::Test::UploadedFile.new(File.join(Rails.root, 'spec', 'files', 't.jpeg'), "image/jpeg") }
    let(:sketch) { user.splatoon2_sketches.create!(name: 'hoge', image: file) }

    it do
      file.rewind
      expected = file.read
      file.rewind
      expect(sketch.decoded_image).to eq([expected, 'image/jpeg'])
    end
  end
end
