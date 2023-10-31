require_relative 'shot.rb'

class Frame
  attr_reader :frame_number, :first_shot, :second_shot, :third_shot

  def initialize(frame_number, marks)
    @frame_number = frame_number
    @first_shot = Shot.score(marks[0])
    @second_shot = Shot.score(marks[1])
    @third_shot = marks.nil? ? 0 : Shot.score(marks[2])
  end

  def score(next_frame = nil, after_next_frame = nil)
    last_frame? ? summed_up_shots : summed_up_shots + add_bonus(next_frame, after_next_frame)
  end

  def summed_up_shots
    [first_shot, second_shot, third_shot].sum
  end

  private

  def last_frame?
    frame_number == 10
  end

  def add_bonus(next_frame, after_next_frame)
    if strike?
      if next_last_frame?
        next_frame.first_shot + next_frame.second_shot
      elsif double?(next_frame)
        next_frame.first_shot + after_next_frame.first_shot
      else
        next_frame.summed_up_shots
      end
    elsif spare?
      next_frame.first_shot
    else
      0
    end
  end

  def strike?
    first_shot == 10
  end
  
  def next_last_frame?
    frame_number == 9
  end

  def double?(next_frame)
    next_frame.first_shot == 10
  end

  def spare?
    [first_shot, second_shot].sum == 10
  end
end
