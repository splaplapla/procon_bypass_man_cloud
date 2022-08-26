require 'rails_helper'

RSpec.describe Splatoon2Sketch, type: :model do
  let(:user) { FactoryBot.create(:user) }


  describe '#encoded_image' do
    let(:file) { Rack::Test::UploadedFile.new(File.join(Rails.root, 'spec', 'files', 'dummy.gif'), "image/gif") }
    let(:sketch) { user.splatoon2_sketches.create!(name: 'hoge', image: file) }

    it do
      expect(sketch.encoded_image).to start_with('image/gif;base64,')
    end
  end

  describe '#decode_image' do
    let(:file) { Rack::Test::UploadedFile.new(File.join(Rails.root, 'spec', 'files', 'dummy.gif'), "image/gif") }
    let(:sketch) { user.splatoon2_sketches.create!(name: 'hoge', image: file) }

    it do
      file.rewind
      expected = file.read
      file.rewind
      expect(sketch.decoded_image).to eq([expected, 'image/gif'])
    end
  end
end
