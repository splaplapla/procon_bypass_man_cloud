class GenerateSplatoon2SketchMacrosService
  # @param [Array<Array<Boolean>>] list_in_list trueが黒で、falseが白
  # [ [true, false, true...],
  #   [true, false, true...],
  #   ...
  def initialize(list_in_list: )
    @list_in_list = list_in_list
  end
end
