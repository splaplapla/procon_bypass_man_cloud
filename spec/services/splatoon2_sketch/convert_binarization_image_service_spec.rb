require 'rails_helper'

describe Splatoon2SketchService::ConvertBinarizationImageService do
  let(:file) { Rack::Test::UploadedFile.new(File.join(Rails.root, 'spec', 'files', 'dummy.gif'), "image/gif") }

  describe '#execute' do
    it do
      expect(described_class.new(image_data: file.read, threshold: 40, file_content_type: 'image/gif').execute).to be_a(Tempfile)
    end
  end
end
