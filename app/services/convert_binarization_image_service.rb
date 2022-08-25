class ConvertBinarizationImageService < BaseConvertBinarizationImageService
  # @param [String] image_data
  # @param [Integer] threshold 白黒の閾値
  # @param [String] file_content_type
  def initialize(image_data: , threshold: , file_content_type: )
    @image_data = image_data
    @threshold = threshold
    @file_extension = file_content_type.match('\Aimage/(.+)\z')[1]
  end

  def convert_cmd 
    "convert -threshold #{@threshold} #{input_file.path} #{output_file.path}"
  end
end
