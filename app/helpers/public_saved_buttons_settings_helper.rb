module PublicSavedButtonsSettingsHelper
  # @param [String] text
  def remove_comment_out_lines(text)
    text&.gsub(/\s+#.*$/, "")
  end
end
