def keitai_message(input)
  testcase = input.split(/0+/)
  testcase.delete('')

  patterns = {
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

  result = ''
  testcase.each do |s|
    i = s[0].to_i
    pattern = patterns[i]
    case i
    when 1
      if s.count('1-9') % 5 == 0
        result += pattern[4]
      else
        result += pattern[s.count('1-9') % 5 - 1]
      end
    when 9
      if s.count('1-9') % 4 == 0
        result += pattern[3]
      else
        result += pattern[s.count('1-9') % 4 - 1]
      end
    else
      if s.count('1-9') % 3 == 0
        result += pattern[2]
      else
        result += pattern[s.count('1-9') % 3 - 1]
      end
    end
  end

  result
end
