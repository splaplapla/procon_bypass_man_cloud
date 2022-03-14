class SettingExplainService
  def initialize(text: )
    @text = text
  end

  def execute
    return [] if @text == '' || @text.nil?
    lines_exclude_prefix_space = @text.lines.map do |line|
      line.gsub(/^\s+/, '').chomp
    end

    # remove comment
    lines_exclude_prefix_space = lines_exclude_prefix_space.map do |line|
      line.gsub(/^#+.*$/, '')
    end

    # remove empty lines
    lines = lines_exclude_prefix_space.compact.reject { |x| x == '' }

    lines
  end
end
