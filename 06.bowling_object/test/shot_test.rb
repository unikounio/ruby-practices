# frozen_string_literal: true

require 'minitest/autorun'
require_relative '../shot'

class ShotTest < Minitest::Test
  def test_shot_score
    assert_equal 10, Shot.score('X')
  end
end
