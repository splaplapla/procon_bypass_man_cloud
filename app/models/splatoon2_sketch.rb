class Splatoon2Sketch < ApplicationRecord
  belongs_to :user

  def image=(file)
    prefix = "#{file.content_type};base64"
    self.encoded_image = "#{prefix},#{Base64.encode64(file.read)}"
  end
end
