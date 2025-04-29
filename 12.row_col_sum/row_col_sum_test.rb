require 'minitest/autorun'
require_relative './row_col_sum'

class FizzBuzzTest < Minitest::Test
  def test_row_col_sum
    input = [
      [9, 85, 92, 20],
      [68, 25, 80, 55],
      [43, 96, 71, 73],
      [43, 19, 20, 87],
      [95, 66, 73, 62]
    ]

    expected = [
      [9, 85, 92, 20, 206],
      [68, 25, 80, 55, 228],
      [43, 96, 71, 73, 283],
      [43, 19, 20, 87, 169],
      [95, 66, 73, 62, 296],
      [258, 291, 336, 297, 1182]
    ]
    
    assert_equal expected, row_col_sum(input)
  end
end
