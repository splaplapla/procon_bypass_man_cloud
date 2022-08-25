class Splatoon2Sketch < ApplicationRecord
  belongs_to :user

  serialize :crop_data, JSON

  # @param [..::UploadedFile] file
  def image=(file)
    self.encoded_image = Lib::Image2Base64.new(file).execute
  end

  # @return [String, String] binary, file extension
  def decoded_image
    Lib::Base642Image.new(encoded_image).execute
  end

  def crop_data=(value)
    if value.is_a?(Hash)
      super
    else
      super(JSON.parse(value))
    end
  end

  def convert_cmd_crop_arg
    x = crop_data["x"].to_i
    y = crop_data["y"].to_i
    width = crop_data["width"].to_i
    height = crop_data["height"].to_i
    "-crop #{width}x#{height}+#{x}+#{y}"
  end
end
