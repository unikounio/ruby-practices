def keitai_message(input)
  numbers = input.lines.map(&:chomp)
  testcase_count = numbers.shift
  testcases = numbers.map { |a| a.split(/0+/)}
  testcases.each do |testcase|
    if testcase[0].empty?
      testcase.shift
    end
  end

  patterns =
  { 1 => ['\'', ',', '!', '?', ' '],
    2 => %w[a b c],
    3 => %w[d e f],
    4 => %w[g h i],
    5 => %w[j k l],
    6 => %w[m n o],
    7 => %w[p q r s],
    8 => %w[t u v],
    9 => %w[w x y z]
  }

  results = testcases.map do |testcase|
    result = ''

    testcase.each do |s|
      pattern = patterns[s[0].to_i]
      case s[0].to_i
      when 1
        if s.count('1-9') % 5 == 0
          result << pattern[4]
        else
          result << pattern[s.count('1-9') % 5 - 1]
        end
      when 9
        if s.count('1-9') % 4 == 0
          result << pattern[3]
        else
          result << pattern[s.count('1-9') % 4 - 1]
        end
      else
        if s.count('1-9') % 3 == 0
          result << pattern[2]
        else
          result << pattern[s.count('1-9') % 3 - 1]
        end
      end
    end
    result
  end
  
  results.join("\n") + "\n"
end
