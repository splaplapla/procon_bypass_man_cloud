class BaseConvertBinarizationImageService
  # @return [File] 画像ファイル
  def execute
    input_file.write(@image_data)
    input_file.rewind
    Rails.logger.debug { convert_cmd }
    `#{convert_cmd}`
    output_file.rewind
    input_file.close

    return output_file
  end

  # @return [String]
  def convert_cmd
    raise NotImplementedError
  end

  private

  def input_file
    @input_file ||= Tempfile.new(['in', ".#{@file_extension}"], binmode: true)
  end

  def output_file
    @output_file ||= Tempfile.new(['out', ".#{@file_extension}"], binmode: true)
  end
end
