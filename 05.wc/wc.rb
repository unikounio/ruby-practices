# frozen_string_literal: true

require 'optparse'

LINES_WIDTH = 7
WORDS_AND_CHARACTERS_WIDTH = 8

def main
  options = parse_options

  if ARGV.empty?
    print_lines_words_characters_from_standard_input(options)
  else
    print_lines_words_characters_and_total_from_argv(options)
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

def print_lines_words_characters_from_standard_input(options)
  lines_words_characters = calculate_lines_words_characters($stdin)
  print_lines_words_characters(lines_words_characters[:lines], lines_words_characters[:words], lines_words_characters[:characters], options)
  puts
end

def calculate_lines_words_characters(input_source)
  lines = 0
  words = 0
  characters = 0

  input_source.each_line do |line|
    lines += 1
    words += line.split.size
    characters += line.bytesize
  end

  { lines:, words:, characters: }
end

def print_lines_words_characters(lines, words, characters, options)
  print lines.to_s.rjust(LINES_WIDTH) if options.include?('-l') || options.empty?
  print words.to_s.rjust(WORDS_AND_CHARACTERS_WIDTH) if options.include?('-w') || options.empty?
  print characters.to_s.rjust(WORDS_AND_CHARACTERS_WIDTH) if options.include?('-c') || options.empty?
end

def print_lines_words_characters_and_total_from_argv(options)
  totals = { total_lines: 0, total_words: 0, total_characters: 0 }

  Dir.glob(ARGV).each do |file_path|
    lines_words_characters =
      if File.directory? File.open(file_path)
        { lines: 0, words: 0, characters: 0 }
      else
        calculate_lines_words_characters(File.open(file_path))
      end

    puts "wc: #{file_path}: Is a directory" if File.directory? file_path
    print_lines_words_characters(lines_words_characters[:lines], lines_words_characters[:words], lines_words_characters[:characters], options)
    puts " #{file_path}"

    calculate_total_lines_words_characters(lines_words_characters, totals)
  end

  return if ARGV.length == 1

  print_lines_words_characters(totals[:total_lines], totals[:total_words], totals[:total_characters], options)
  puts ' total'
end

def calculate_total_lines_words_characters(lines_words_characters, totals)
  totals[:total_lines] += lines_words_characters[:lines]
  totals[:total_words] += lines_words_characters[:words]
  totals[:total_characters] += lines_words_characters[:characters]
  totals
end

main
