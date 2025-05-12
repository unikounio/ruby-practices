require 'date'

def serial_search(input)
  y = 1900 + (input[0] + input[4]).to_i
  d = input[1..3].to_i
  x = input[5..7].to_i

  first_date = Date.new(y)
  m_date = first_date + (d - 1)

  f, n = (1..499).include?(x) ? ['カラマズー', x] : ['ナッシュビル', x - 500]

  "#{m_date.year}年#{m_date.month}月#{m_date.day}日に#{f}・ファクトリーで#{n}番目に製造されたギターです"
end
