# frozen_string_literal: true

require_relative 'shot'

class Frame
  attr_reader :frame_number, :first_shot, :second_shot, :third_shot
  attr_accessor :next_frame

  def initialize(frame_shot_marks, frame_number)
    @frame_number = frame_number
    @first_shot = Shot.new(frame_shot_marks[0])
    @second_shot = Shot.new(frame_shot_marks[1])
    @third_shot = Shot.new(frame_shot_marks[2])
  end

  def score
    last_frame? ? summed_up_shots : summed_up_shots + add_bonus
  end

  def summed_up_shots
    [first_shot.score, second_shot.score, third_shot.score].sum
  end

  private

  def last_frame?
    frame_number == 10
  end

  def add_bonus
    if strike?
      strike_bonus
    elsif spare?
      next_frame.first_shot.score
    else
      0
    end
  end

  def strike?
    first_shot.score == 10
  end

  def strike_bonus
    if next_last_frame?
      next_frame.first_shot.score + next_frame.second_shot.score
    elsif double?
      after_next_frame = next_frame.next_frame
      next_frame.first_shot.score + after_next_frame.first_shot.score
    else
      next_frame.summed_up_shots
    end
  end

  def next_last_frame?
    frame_number == 9
  end

  def double?
    next_frame.first_shot.score == 10
  end

  def spare?
    [first_shot.score, second_shot.score].sum == 10
  end
end
