class ConvertBinarizationImageService2

  # @param [String] image_data
  # @param [Integer] threshold
  def initialize(image_data: , threshold: , file_content_type: , crop_arg: )
    @image_data = image_data
    @threshold = threshold
    @file_extension = file_content_type.match('\Aimage/(.+)\z')[1]
    @crop_arg = crop_arg
  end

  # @return [String] 画像データ
  def execute
    input_file.write(@image_data)
    input_file.rewind
    convert_cmd = "convert #{@crop_arg} -threshold #{@threshold} -resize 320x120! #{input_file.path} #{output_file.path}"
    Rails.logger.debug { convert_cmd }
    `#{convert_cmd}`
    output_file.rewind
    input_file.close

    return output_file
  end

  private

  def input_file
    @input_file ||= Tempfile.new(['in', ".#{@file_extension}"], binmode: true)
  end

  def output_file
    @output_file ||= Tempfile.new(['out', ".#{@file_extension}"], binmode: true)
  end
end
