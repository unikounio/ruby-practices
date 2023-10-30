require 'minitest/autorun'
require_relative '../shot.rb'

class ShotTest < Minitest::Test
  def test_shot #TODO: shotのテストメソッド名具体化
    shot = Shot.new('X')
    assert_equal 'X', shot.mark
    assert_equal 10, shot.score
  end
end
