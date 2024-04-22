class Splatoon2Sketch < ApplicationRecord
  belongs_to :user

  serialize :crop_data, coder: JSON

  validates :encoded_image, presence: true
  validate :validate_image_extension, if: :encoded_image?

  # @param [..::UploadedFile] file
  def image=(file)
    self.encoded_image = Lib::Image2Base64.new(file).execute
  end

  def crop_data=(value)
    if value.is_a?(Hash)
      super
    else
      super(JSON.parse(value))
    end
  end

  # decoratorとかに移動したい
  # @return [String, String] binary, file extension
  def decoded_image
    Lib::Base642Image.new(encoded_image).execute
  end

  private

  # @return [void]
  def validate_image_extension
    if self.encoded_image.start_with?("image/gif")
      errors.add(:encoded_image, :not_support_gif)
    end
  end
end
