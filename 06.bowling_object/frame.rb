# frozen_string_literal: true

require_relative 'shot'

class Frame
  attr_reader :frame_number, :first_shot, :second_shot, :third_shot

  def initialize(frame_marks, frame_number)
    @frame_number = frame_number
    @first_shot = Shot.score(frame_marks[0])
    @second_shot = Shot.score(frame_marks[1])
    @third_shot = Shot.score(frame_marks[2])
  end

  def score(next_frame = nil, after_next_frame = nil)
    last_frame? ? summed_up_shots : summed_up_shots + add_bonus(next_frame, after_next_frame)
  end

  def summed_up_shots
    [first_shot, second_shot, third_shot].sum
  end

  def self.organize_shots_into_frames(shot_marks)
    frames = []
    current_frame = []
    shot_marks.each do |shot|
      frames << [] if next_frame?(frames, current_frame)
      current_frame = frames.last
      current_frame << shot
    end
    frames
  end

  private

  def last_frame?
    frame_number == 10
  end

  def add_bonus(next_frame, after_next_frame)
    if strike?
      strike_bonus(next_frame, after_next_frame)
    elsif spare?
      next_frame.first_shot
    else
      0
    end
  end

  def strike?
    first_shot == 10
  end

  def strike_bonus(next_frame, after_next_frame)
    if next_last_frame?
      next_frame.first_shot + next_frame.second_shot
    elsif double?(next_frame)
      next_frame.first_shot + after_next_frame.first_shot
    else
      next_frame.summed_up_shots
    end
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

  def self.next_frame?(frames, current_frame)
    not_last_frame?(frames) && (frames.empty? || current_frame[0] == 'X' || current_frame.size == 2)
  end

  def self.not_last_frame?(frames)
    frames.size != 10
  end
end
