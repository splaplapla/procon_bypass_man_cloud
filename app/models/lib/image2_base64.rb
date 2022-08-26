class Lib::Image2Base64 < Lib::Base64Converter
  def initialize(file, content_type: nil)
    @prefix = generate_prefix(content_type || file.content_type)
    @binary = file.read
  end

  def execute
    "#{@prefix}#{Base64.encode64(@binary)}"
  end
end
