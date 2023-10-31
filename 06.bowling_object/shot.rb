# frozen_string_literal: true

class Shot
  def self.score(mark)
    return 10 if mark == 'X'

    mark.to_i
  end
end
