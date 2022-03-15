class SettingExplainService
  def initialize(text: )
    @text = text
    @explaining = []
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

    lines.each do |line|
      if /^flip :(\w+?),/ =~ line && $1
        @explaining << "#{$1.upcase}ボタンを連打"
      end
    end

    lines.each do |line|
      if /^remap :(\w+?), to: :(\w+?)/ =~ line && $1 && $2
        @explaining << "#{$1.upcase}ボタンを#{$2.upcase}ボタンへリマップ"
      end
    end

    lines.each do |line|
      if /^macro ([\w:]+?),/ =~ line && $1
        @explaining << "#{Object.const_get($1).description}のマクロを設定"
      end
    end

    @explaining.uniq
  end
end
