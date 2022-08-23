class ConvertBinarizationImageService

  # @param [String] image_data
  # @param [Integer] threshold
  def initialize(image_data: , threshold: , file_content_type: )
    @image_data = image_data
    @threshold = threshold
    @file_extension = file_content_type.match('\Aimage/(.+)\z')[1]
  end

  # @return [String] 画像データ
  def execute
    input_file.write(@image_data)
    input_file.rewind
    convert_cmd = "convert -threshold #{@threshold} #{input_file.path} #{output_file.path}"
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
