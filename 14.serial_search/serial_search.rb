# frozen_string_literal: true

require 'date'

def serial_search(input)
  year = 1900 + (input[0] + input[4]).to_i
  days = input[1..3].to_i
  production = input[5..7].to_i

  first_date = Date.new(year)
  manufactured = first_date + (days - 1)

  factory, order = (1..499).cover?(production) ? ['カラマズー', production] : ['ナッシュビル', production - 500]

  "#{year}年#{manufactured.month}月#{manufactured.day}日に#{factory}・ファクトリーで#{order}番目に製造されたギターです"
end
