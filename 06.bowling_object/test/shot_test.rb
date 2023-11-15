# frozen_string_literal: true

require 'minitest/autorun'
require_relative '../shot'

class ShotTest < Minitest::Test
  def test_shot_score
    shot = Shot.new('X')
    assert_equal 10, shot.score
  end
end
