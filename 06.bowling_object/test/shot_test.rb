# frozen_string_literal: true

require 'minitest/autorun'
require_relative '../shot'

class ShotTest < Minitest::Test
  # TODO: shotのテストメソッド名具体化
  def test_shot_score
    shot = Shot.new('X')
    assert_equal 'X', shot.mark
    assert_equal 10, shot.score
  end
end
