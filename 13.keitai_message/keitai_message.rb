PATTERNS = {
  1 => %w[' , ! ? \ ],
  2 => %w[a b c],
  3 => %w[d e f],
  4 => %w[g h i],
  5 => %w[j k l],
  6 => %w[m n o],
  7 => %w[p q r s],
  8 => %w[t u v],
  9 => %w[w x y z]
}

def keitai_message(input)
  testcase = input.split(/0+/)
  testcase.delete('')

  result = ''
  testcase.each do |s|
    i = s[0].to_i
    pattern = PATTERNS[i]
    index = (s.length - 1) % pattern.length
    result += pattern[index]
  end

  result
end
