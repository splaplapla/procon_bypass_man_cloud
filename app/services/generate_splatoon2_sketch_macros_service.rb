# frozen_string_literal: true

# 一番左上から開始して、右に行ったら下に移動して折り返す
class GenerateSplatoon2SketchMacrosService
  # 偶数. 右へ移動する
  MACRO_POINT = ['pressing_a_for_%{dotting_speed}sec', 'pressing_right_for_%{dotting_speed}sec']
  MACRO_NOT_POINT = ['wait_for_%{dotting_speed}sec', 'pressing_right_for_%{dotting_speed}sec']

  # 奇数. 左へ移動する
  MACRO_REVERSE_POINT = ['pressing_a_for_%{dotting_speed}sec', 'pressing_left_for_%{dotting_speed}sec']
  MACRO_REVERSE_NOT_POINT = ['wait_for_%{dotting_speed}sec', 'pressing_left_for_%{dotting_speed}sec']

  MACRO_NEXT_LINE = ['pressing_down_for_%{dotting_speed}sec']

  # @param [Array<Array<Boolean>>] list_in_list trueが黒で、falseが白
  # [ [true, false, true, ...],
  #   [true, true, true...],
  #   ...
  def initialize(list_in_list: , dotting_speed: )
    @list_in_list = list_in_list
    dotting_speed_setter = proc { |x| (x % { dotting_speed: dotting_speed.to_s.gsub(".", "_") }) }

    @macro_point = MACRO_POINT.map(&dotting_speed_setter)
    @macro_not_point = MACRO_NOT_POINT.map(&dotting_speed_setter)
    @macro_reverse_point = MACRO_REVERSE_POINT.map(&dotting_speed_setter)
    @macro_reverse_not_point = MACRO_REVERSE_NOT_POINT.map(&dotting_speed_setter)
    @macro_next_line = MACRO_NEXT_LINE.map(&dotting_speed_setter)
  end

  def execute
    @list_in_list.map.with_index do |in_list, row_index|
      (row_index.even? ? in_list : in_list.reverse).map { |item|
        if row_index.even?
          item ? @macro_point : @macro_not_point
        else
          item ? @macro_reverse_point : @macro_reverse_not_point
        end
      } << @macro_next_line
    end
  end
end
