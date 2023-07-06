# frozen_string_literal: true

require 'optparse'

LINES_WIDTH = 7
WORDS_AND_CHARACTERS_WIDTH = 8

def main
  options = define_options

  if ARGV.empty?
    wc = calculate_wc($stdin)
    print_results(wc, options)
  else
    total_wc = calculate_total_wc(options)
    print_total_results(total_wc, options)
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

  { lines:, words:, characters: }
end

def print_results(result, options, argument = '')
  puts "wc: #{argument}: Is a directory" if File.directory? argument
  print result[:lines].to_s.rjust(LINES_WIDTH) if options.include?('-l') || options.empty?
  print result[:words].to_s.rjust(WORDS_AND_CHARACTERS_WIDTH) if options.include?('-w') || options.empty?
  print result[:characters].to_s.rjust(WORDS_AND_CHARACTERS_WIDTH) if options.include?('-c') || options.empty?
  puts " #{argument}"
end

def calculate_total_wc(options)
  total_lines = 0
  total_words = 0
  total_characters = 0

  Dir.glob(ARGV).each do |argument|
    wc = calculate_wc(File.open(argument))
    print_results(wc, options, argument)

    total_lines += wc[:lines]
    total_words += wc[:words]
    total_characters += wc[:characters]
  end

  exit if ARGV.length == 1
  { total_lines:, total_words:, total_characters: }
end

def print_total_results(total_result, options)
  print total_result[:total_lines].to_s.rjust(LINES_WIDTH) if options.include?('-l') || options.empty?
  print total_result[:total_words].to_s.rjust(WORDS_AND_CHARACTERS_WIDTH) if options.include?('-w') || options.empty?
  print total_result[:total_characters].to_s.rjust(WORDS_AND_CHARACTERS_WIDTH) if options.include?('-c') || options.empty?
  puts ' total'
end

main
