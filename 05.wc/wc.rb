def main
  total_lines = 0
  total_words = 0
  total_characters = 0

  input_sources = ARGV.empty? ? $stdin : Dir.glob(ARGV)
  
  if input_sources == $stdin
    lines = 0
    words = 0
    characters = 0
    input_sources.each_line do |line|
      lines += 1
      words += line.split.size
      characters += line.bytesize
    end
    print "#{lines}".rjust(7)
    print "#{words}".rjust(8)
    print "#{characters}".rjust(8)
    puts ""
  else
    input_sources.each do |input_source|
      lines = 0
      words = 0
      characters = 0
      if File.file? input_source
        File.open(input_source).each_line do |line|
          lines += 1
          words += line.split.size
          characters += line.bytesize
        end
      else
        puts "wc: #{input_source}: ディレクトリです"
      end
    
      if ARGV.length == 1 && File.file?(input_source)
        print " #{lines}  #{words} #{characters}"
      else
        print "#{lines}".rjust(7)
        print "#{words}".rjust(8)
        print "#{characters}".rjust(8)
      end
      print " #{input_source}"
      puts ""

      total_lines += lines
      total_words += words
      total_characters += characters
    end
    
    if ARGV.length > 1
      print "#{total_lines}".rjust(7)
      print "#{total_words}".rjust(8)
      print "#{total_characters}".rjust(8)
      puts ' 合計'
    end
  end
end

main
