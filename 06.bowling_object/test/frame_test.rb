# frozen_string_literal: true

require 'minitest/autorun'
require_relative '../frame'

class FrameTest < Minitest::Test
  # TODO: メソッドのテストを書けるだけ書く
  def test_frame_score
    frame = Frame.new('1', '9')
    assert_equal 10, frame.score
  end
end
