class SettingExplainService
  def initialize(text: )
    @text = text
  end

  def execute
    return [] if @text == '' || @text.nil?
  end
end
