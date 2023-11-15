# frozen_string_literal: true

class Shot
  attr_reader :shot_mark

  def initialize(shot_mark)
    @shot_mark = shot_mark
  end

  def score
    return 10 if shot_mark == 'X'

    shot_mark.to_i
  end
end
