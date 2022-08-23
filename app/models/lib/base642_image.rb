class Lib::Base642Image < Lib::Base64Converter
  def initialize(encoded)
    @plain_decoded, @file_extension = remove_prefix(encoded)
  end

  def execute
    return [Base64.decode64(@plain_decoded), @file_extension]
  end
end

