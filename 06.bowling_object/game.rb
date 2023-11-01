# frozen_string_literal: true

require_relative 'frame'

class Game
  attr_reader :frames

  def initialize(shots_text)
    shot_marks = shots_text.split(',')
    frames_shot_marks = organize_shots_into_frames(shot_marks)
    @frames = frames_shot_marks.map.with_index(1) do |frame_shots, frame_number|
      Frame.new(frame_shots, frame_number)
    end
    set_frame_relations
  end

  def score
    frames.sum(&:score)
  end

  private

  def organize_shots_into_frames(shot_marks)
    frames_shot_shots = []
    current_frame = []
    shot_marks.each do |shot|
      frames_shot_shots << [] if next_frame?(frames_shot_shots, current_frame)
      current_frame = frames_shot_shots.last
      current_frame << shot
    end
    frames_shot_shots
  end

  def next_frame?(frames_shot_shots, current_frame)
    not_last_frame?(frames_shot_shots) && (frames_shot_shots.empty? || strike?(current_frame) || current_frame.size == 2)
  end

  def not_last_frame?(frames_shot_shots)
    frames_shot_shots.size != 10
  end

  def strike?(current_frame)
    current_frame[0] == 'X'
  end

  def set_frame_relations
    frames.each_with_index do |frame, index|
      frame.next_frame = @frames[index + 1]
      frame.after_next_frame = @frames[index + 2]
    end
  end
end
