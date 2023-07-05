# frozen_string_literal: true

require 'optparse'

def main
  options = define_options
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
    print "#{lines}".rjust(8) if options.include?('-l') || options.empty?
    print "#{words}".rjust(8) if options.include?('-w') || options.empty?
    print "#{characters}".rjust(8) if options.include?('-c') || options.empty?
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
    
      print "#{lines}".rjust(8) if options.include?('-l') || options.empty?
      print "#{words}".rjust(8) if options.include?('-w') || options.empty?
      print "#{characters}".rjust(8) if options.include?('-c') || options.empty?
      
      print " #{input_source}"
      puts ""

      total_lines += lines
      total_words += words
      total_characters += characters
    end
    
    if ARGV.length > 1
      print "#{total_lines}".rjust(8) if options.include?('-l') || options.empty?
      print "#{total_words}".rjust(8) if options.include?('-w') || options.empty?
      print "#{total_characters}".rjust(8) if options.include?('-c') || options.empty?
      puts ' 合計'
    end
  end
end

def define_options
  opt = OptionParser.new
  options = []
  opt.on('-l') { options << '-l' }
  opt.on('-w') { options << '-w' }
  opt.on('-c') { options << '-c' }
  opt.parse!(ARGV)
  options
end

main
