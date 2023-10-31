# frozen_string_literal: true

require_relative 'frame'

class Game
  attr_reader :frames

  def initialize(shots_text)
    shot_marks = shots_text.split(',')
    frame_marks = Frame.organize_shots_into_frames(shot_marks)
    @frames = frame_marks.map.with_index(1) do |frame_marks, frame_number|
      Frame.new(frame_marks, frame_number)
    end
  end

  def score
    frames.each_with_index.sum do |frame, index|
      frame.score(frames[index + 1], frames[index + 2])
    end
  end
end
