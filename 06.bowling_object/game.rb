require_relative 'frame.rb'

class Game
  ALL_PINS_DOWN = 10

  attr_reader :first_frame, :second_frame, :third_frame, :fourth_frame, :fifth_frame, :sixth_frame, :seventh_frame, :eighth_frame, :ninth_frame, :tenth_frame

  def initialize(marks)
    split_marks = marks.split(',').map do |mark|
      if mark == 'X'
        ['X', '0']
      else
        mark
      end
    end

    split_align_marks = split_marks.flatten

    @first_frame = Frame.new(1, split_align_marks[0], split_align_marks[1])
    @second_frame = Frame.new(2, split_align_marks[2], split_align_marks[3])
    @third_frame = Frame.new(3, split_align_marks[4], split_align_marks[5])
    @fourth_frame = Frame.new(4, split_align_marks[6], split_align_marks[7])
    @fifth_frame = Frame.new(5, split_align_marks[8], split_align_marks[9])
    @sixth_frame = Frame.new(6, split_align_marks[10], split_align_marks[11])
    @seventh_frame = Frame.new(7, split_align_marks[12], split_align_marks[13])
    @eighth_frame = Frame.new(8, split_align_marks[14], split_align_marks[15])
    @ninth_frame = Frame.new(9, split_align_marks[16], split_align_marks[17])
    @tenth_frame =
      if split_align_marks[18] == 'X' || split_align_marks[18] + split_align_marks[19] == ALL_PINS_DOWN
        Frame.new(10, split_align_marks[18], split_align_marks[19], split_align_marks[20])
      else
        Frame.new(10, split_align_marks[18], split_align_marks[19])
      end
  end

  def score
    [first_frame.score,
    second_frame.score,
    third_frame.score,
    fourth_frame.score,
    fifth_frame.score,
    sixth_frame.score,
    seventh_frame.score,
    eighth_frame.score,
    ninth_frame.score,
    tenth_frame.score].sum
  end
end
