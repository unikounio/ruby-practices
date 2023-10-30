require 'minitest/autorun'
require_relative '../frame.rb'

class FrameTest < Minitest::Test
  def test_frame #TODO: frameのテストメソッド名具体化
    frame = Frame.new('1', '9')
    assert_equal 10, frame.score
  end
end
