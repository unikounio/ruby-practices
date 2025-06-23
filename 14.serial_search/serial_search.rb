# frozen_string_literal: true

require 'date'

NASHVILLE_SERIAL_START = 500

def serial_search(input)
  year = "19#{input[0]}#{input[4]})".to_i
  days = input[1..3].to_i
  production_no = input[5..7].to_i

  beginning_of_year = Date.new(year)
  manufactured_on = beginning_of_year + days - 1

  factory, order = (1..499).cover?(production_no) ? ['カラマズー', production_no] : ['ナッシュビル', production_no - 500]

  "#{year}年#{manufactured_on.month}月#{manufactured_on.day}日に#{factory}・ファクトリーで#{order}番目に製造されたギターです"
end
