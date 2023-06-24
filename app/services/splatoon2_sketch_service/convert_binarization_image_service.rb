module Splatoon2SketchService
  class ConvertBinarizationImageService < Splatoon2SketchService::BaseConvertBinarizationImageService
    # @param [String] image_data
    # @param [Integer] threshold 白黒の閾値
    # @param [String] file_content_type
    def initialize(image_data: , threshold: , file_content_type: )
      @image_data = image_data
      @threshold = threshold
      @file_extension = file_content_type.match('\Aimage/(.+)\z')[1]
      super()
    end

    def convert_cmd
      "convert -alpha off -threshold #{@threshold}% -depth 1 #{input_file.path} #{output_file.path}"
    end
  end
end
