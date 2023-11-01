# frozen_string_literal: true

require 'minitest/autorun'
require_relative '../game'

class FrameTest < Minitest::Test
  def setup
    @game = Game.new('X,X,1,9,2,3,8,1,7,3,X,9,1,X,1,9,X')
  end

  def test_last_frame_score
    last_frame = @game.frames.last
    assert_equal 20, last_frame.score
  end

  def test_ninth_frame_strike
    ninth_frame = @game.frames[8]
    @game.frames[9]

    assert_equal 20, ninth_frame.score
  end

  def test_double_strike_score
    first_frame = @game.frames[0]
    @game.frames[1]
    @game.frames[2]

    assert_equal 21, first_frame.score
  end

  def test_single_strike_score
    second_frame = @game.frames[1]
    @game.frames[2]

    assert_equal 20, second_frame.score
  end

  def test_spare_score
    third_frame = @game.frames[2]
    @game.frames[3]

    assert_equal 12, third_frame.score
  end

  def test_normal_frame_score
    fourth_frame = @game.frames[3]
    assert_equal 5, fourth_frame.score
  end

  def test_total_frame_score
    fifth_frame = @game.frames[4]
    assert_equal 9, fifth_frame.summed_up_shots
  end
end
