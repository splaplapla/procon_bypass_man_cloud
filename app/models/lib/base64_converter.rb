class Lib::Base64Converter
  def generate_prefix(content_type)
    "#{content_type};base64,"
  end

  def remove_prefix(encoded)
    extension = encoded.match(/\A(image\/[^;]+);base64,/)[1]
    return [encoded.remove(/\A[^;]+;base64,/), extension]
  end
end
