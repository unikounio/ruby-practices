# frozen_string_literal: true

require 'optparse'

LINES_WIDTH = 7
WORDS_AND_CHARACTERS_WIDTH = 8

def main
  options = parse_options

  if ARGV.empty?
    print_statistics_from_standard_input(options)
  else
    print_statistics_and_total_from_argv(options)
  end
end

def parse_options
  options = {}

  OptionParser.new do |opt|
    opt.on('-l') { options[:lines] = true }
    opt.on('-w') { options[:words] = true }
    opt.on('-c') { options[:characters] = true }
    opt.parse!(ARGV)
  end

  options = {lines: true, words: true, characters: true} if options.empty?
  options
end

def print_statistics_from_standard_input(options)
  statistics = calculate_statistics($stdin)
  print_statistics(statistics, options)
  puts
end

def calculate_statistics(input_source)
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

def print_statistics(statistics, options)
  print statistics[:lines].to_s.rjust(LINES_WIDTH) if options[:lines]
  print statistics[:words].to_s.rjust(WORDS_AND_CHARACTERS_WIDTH) if options[:words]
  print statistics[:characters].to_s.rjust(WORDS_AND_CHARACTERS_WIDTH) if options[:characters]
end

def print_statistics_and_total_from_argv(options)
  totals = { lines: 0, words: 0, characters: 0 }

  Dir.glob(ARGV).each do |file_path|
    statistics =
      if File.directory? file_path
        { lines: 0, words: 0, characters: 0 }
      else
        calculate_statistics(File.read(file_path))
      end

    puts "wc: #{file_path}: Is a directory" if File.directory? file_path
    print_statistics(statistics, options)
    puts " #{file_path}"

    totals[:lines] += statistics[:lines]
    totals[:words] += statistics[:words]
    totals[:characters] += statistics[:characters]
  end

  return if ARGV.length == 1

  print_statistics(totals, options)
  puts ' total'
end

main
