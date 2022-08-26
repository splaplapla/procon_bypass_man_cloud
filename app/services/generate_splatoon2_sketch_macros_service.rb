# 一番左上から開始して、右に行ったら下に移動して折り返す
class GenerateSplatoon2SketchMacrosService
  # 偶数. 右へ移動する
  MACRO_POINT = [:pressing_a_for_0_02sec, :pressing_right_for_0_02sec]
  MACRO_NOT_POINT = [:wait_for_0_02sec, :pressing_right_for_0_02sec]

  # 奇数. 左へ移動する
  MACRO_REVERSE_POINT = [:pressing_a_for_0_02sec, :pressing_left_for_0_02sec]
  MACRO_REVERSE_NOT_POINT = [:wait_for_0_02sec, :pressing_left_for_0_02sec]

  MACRO_NEXT_LINE = [:pressing_down_for_0_02sec]

  # @param [Array<Array<Boolean>>] list_in_list trueが黒で、falseが白
  # [ [true, false, true, ...],
  #   [true, true, true...],
  #   ...
  def initialize(list_in_list: )
    @list_in_list = list_in_list
  end

  def execute
    @list_in_list.map.with_index do |in_list, row_index|
      (row_index.even? ? in_list : in_list.reverse).map { |item|
        if row_index.even?
          item ? MACRO_POINT : MACRO_NOT_POINT
        else
          item ? MACRO_REVERSE_POINT : MACRO_REVERSE_NOT_POINT
        end
      } << MACRO_NEXT_LINE
    end
  end
end
