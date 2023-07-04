def main
  lines = 0
  words = 0
  characters = 0

  if ARGV[0].nil? || File.file?(ARGV[0])
    input_source = ARGV[0].nil? ? $stdin : File.open(ARGV[0])
    input_source.each_line do |line|
      lines += 1
      words += line.split.size
      characters += line.bytesize
    end
  else
    puts "wc: #{ARGV[0]}: ディレクトリです"
  end

  if ARGV[0].nil? || File.directory?(ARGV[0])
    print "#{lines}".rjust(7)
    print "#{words}".rjust(8)
    print "#{characters}".rjust(8)
  else 
    print " #{lines}  #{words} #{characters}"
  end

  print " #{ARGV[0]}" unless ARGV[0].nil?
  puts ""
end

main
