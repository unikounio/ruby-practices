# frozen_string_literal: true

require 'optparse'

STATISTICS_WIDTH = 7

def main
  options = parse_options

  if ARGV.empty?
    print_statistics_from_standard_input(options)
  else
    print_statistics_from_argv(options)
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

  options.empty? ? { lines: true, words: true, characters: true } : options
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
  rjusted_statistics = []
  rjusted_statistics << statistics[:lines].to_s.rjust(STATISTICS_WIDTH) if options[:lines]
  rjusted_statistics << statistics[:words].to_s.rjust(STATISTICS_WIDTH) if options[:words]
  rjusted_statistics << statistics[:characters].to_s.rjust(STATISTICS_WIDTH) if options[:characters]
  print rjusted_statistics.join(' ')
end

def print_statistics_from_argv(options)
  totals = { lines: 0, words: 0, characters: 0 }

  Dir.glob(ARGV).each do |file_path|
    statistics =
      if File.directory? file_path
        puts "wc: #{file_path}: Is a directory"
        { lines: 0, words: 0, characters: 0 }
      else
        calculate_statistics(File.read(file_path))
      end

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
