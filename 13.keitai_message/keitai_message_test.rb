require 'minitest/autorun'
require_relative './keitai_message'

class KeitaiMessageTest < Minitest::Test
  def test_keitai_message
    input = <<~TEXT
      5
      20
      220
      222220
      44033055505550666011011111090666077705550301110
      000555555550000330000444000080000200004440000
      TEXT

    expected = <<~TEXT
      a
      b
      b
      hello, world!
      keitai
      TEXT

    assert_equal expected, keitai_message(input)
  end
end
