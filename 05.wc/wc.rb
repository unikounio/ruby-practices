# frozen_string_literal: true

require 'optparse'

LINES_WIDTH = 7
WORDS_AND_CHARACTERS_WIDTH = 8

def main
  options = parse_options

  if ARGV.empty?
    lines_words_characters = calculate_lines_words_characters($stdin)
    print_results(lines_words_characters, options)
  else
    total_lines = 0
    total_words = 0
    total_characters = 0

    Dir.glob(ARGV).each do |argument|
      lines_words_characters = calculate_lines_words_characters(File.open(argument))
      print_results(lines_words_characters, options, argument)

      total_lines += lines_words_characters[:lines]
      total_words += lines_words_characters[:words]
      total_characters += lines_words_characters[:characters]
    end

    exit if ARGV.length == 1
    print_total_results(total_lines, total_words, total_characters, options)
  end
end

def parse_options
  opt = OptionParser.new
  options = []
  opt.on('-l') { options << '-l' }
  opt.on('-w') { options << '-w' }
  opt.on('-c') { options << '-c' }
  opt.parse!(ARGV)
  options
end

def calculate_lines_words_characters(input_source)
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

  { lines:, words:, characters: }
end

def print_results(result, options, argument = '')
  puts "wc: #{argument}: Is a directory" if File.directory? argument
  print result[:lines].to_s.rjust(LINES_WIDTH) if options.include?('-l') || options.empty?
  print result[:words].to_s.rjust(WORDS_AND_CHARACTERS_WIDTH) if options.include?('-w') || options.empty?
  print result[:characters].to_s.rjust(WORDS_AND_CHARACTERS_WIDTH) if options.include?('-c') || options.empty?
  puts " #{argument}"
end

def print_total_results(total_lines, total_words, total_characters, options)
  print total_lines.to_s.rjust(LINES_WIDTH) if options.include?('-l') || options.empty?
  print total_words.to_s.rjust(WORDS_AND_CHARACTERS_WIDTH) if options.include?('-w') || options.empty?
  print total_characters.to_s.rjust(WORDS_AND_CHARACTERS_WIDTH) if options.include?('-c') || options.empty?
  puts ' total'
end

main
