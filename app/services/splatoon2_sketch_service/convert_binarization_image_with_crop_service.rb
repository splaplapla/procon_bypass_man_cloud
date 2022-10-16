module Splatoon2SketchService
  class ConvertBinarizationImageWithCropService < Splatoon2SketchService::BaseConvertBinarizationImageService
    # @param [String] image_data
    # @param [Integer] threshold 白黒の閾値
    # @param [String] file_content_type
    # @param [String] crop_arg convertコマンドの引数
    def initialize(image_data: , threshold: , file_content_type: , crop_arg: )
      @image_data = image_data
      @threshold = threshold
      @file_extension = file_content_type.match('\Aimage/(.+)\z')[1]
      @crop_arg = crop_arg
    end

    private

    def convert_cmd
      "convert #{@crop_arg} -alpha off -resize 320x120 -depth 1 -threshold #{@threshold}% #{input_file.path} #{output_file.path}"
    end
  end
end
