require 'minitest/autorun'
require_relative './serial_search'

class SerialSearchTest < Minitest::Test
  def test_case1
    input = '73268123'
    expected = '1978年11月22日にカラマズー・ファクトリーで123番目に製造されたギターです'

    assert_equal expected, serial_search(input)
  end

  def test_case2
    input = '80995545'
    expected = '1985年4月9日にナッシュビル・ファクトリーで45番目に製造されたギターです'

    assert_equal expected, serial_search(input)
  end
end
