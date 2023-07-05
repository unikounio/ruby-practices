# frozen_string_literal: true

require 'optparse'

def main
  options = define_options
  total_lines = 0
  total_words = 0
  total_characters = 0

  if ARGV.empty?
    lines, words, characters = calculate_wc($stdin)

    print_wc_results(options, lines, words, characters)
  else
    Dir.glob(ARGV).each do |argument|
      lines, words, characters = calculate_wc(File.open(argument))

      print_wc_results(options, lines, words, characters, argument)
      total_lines += lines
      total_words += words
      total_characters += characters
    end

    if ARGV.length > 1
      print total_lines.to_s.rjust(7) if options.include?('-l') || options.empty?
      print total_words.to_s.rjust(8) if options.include?('-w') || options.empty?
      print total_characters.to_s.rjust(8) if options.include?('-c') || options.empty?
      puts ' total'
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

def calculate_wc(input_source)
  lines = 0
  words = 0
  characters = 0

  unless File.directory? input_source
    input_source.each_line do |line|
      lines += 1
      words += line.split.size
      characters += line.bytesize
    end
  end

  [lines, words, characters]
end

def print_wc_results(options, lines, words, characters, argument = '')
  puts "wc: #{argument}: Is a directory" if File.directory? argument
  print lines.to_s.rjust(7) if options.include?('-l') || options.empty?
  print words.to_s.rjust(8) if options.include?('-w') || options.empty?
  print characters.to_s.rjust(8) if options.include?('-c') || options.empty?
  print " #{argument}"
  puts ''
end

main
