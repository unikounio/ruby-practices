# frozen_string_literal: true

class Shot
  def self.score(shot_mark)
    return 10 if shot_mark == 'X'

    shot_mark.to_i
  end
end
