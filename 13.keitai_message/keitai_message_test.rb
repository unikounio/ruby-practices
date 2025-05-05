require 'minitest/autorun'
require_relative './keitai_message'

class KeitaiMessageTest < Minitest::Test
  def test_keitai_message_case1
    input = '20'
    expected = 'a'

    assert_equal expected, keitai_message(input)
  end

  def test_keitai_message_case2
    input = '220'
    expected = 'b'

    assert_equal expected, keitai_message(input)
  end

  def test_keitai_message_case3
    input = '222220'
    expected = 'b'

    assert_equal expected, keitai_message(input)
  end

  def test_keitai_message_case4
    input = '44033055505550666011011111090666077705550301110'
    expected = 'hello, world!'

    assert_equal expected, keitai_message(input)
  end

  def test_keitai_message_case5
    input = '000555555550000330000444000080000200004440000'
    expected = 'keitai'

    assert_equal expected, keitai_message(input)
  end

  def test_keitai_message_case6
    input = '440330555055506660110111110906660777777705550301110'
    expected = 'hello, world!'

    assert_equal expected, keitai_message(input)
  end

  def test_keitai_message_case7
    input = '5'
    expected = 'j'

    assert_equal expected, keitai_message(input)
  end
end
