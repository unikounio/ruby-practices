def main
  input_source = ARGV[0].nil? ? $stdin : File.open(ARGV[0])

  lines = 0
  words = 0
  characters = 0

  input_source.each_line do |line|
    lines += 1
    words += line.split.size
    characters += line.bytesize
  end

  print "#{lines}".rjust(7)
  print "#{words}".rjust(8)
  puts"#{characters}".rjust(8)
end
main
