require "debug"

# frozen_string_literal: true
require "optparse"

opt = OptionParser.new

option = []

opt.on("-a") {option << "-a" }

opt.parse!(ARGV)

argument = ARGV[0] || '.'

if File.directory? argument
  entries = Dir.entries(argument).sort
elsif File.file? argument
  puts ARGV[0]
else
  puts "ls: \'#{ARGV[0]}\' にアクセスできません: そのようなファイルやディレクトリはありません"
end

exit unless File.directory? argument

def each_slice_into_rows(array, max_columns) = array.each_slice((array.length.to_f / max_columns).ceil).to_a

def pad_to_max_length(arrays) = arrays.map { |array| array + [''] * (arrays.map(&:length).max - array.length) }

def hankaku_ljust(string, width, padding = ' ')
  convert_hankaku = 0

  convert_hankaku = string.each_char.sum { |char| (char.bytesize > 1) ? (char.bytesize - 2) : 0 }

  string.ljust(width - convert_hankaku, padding)
end

if option.include? "-a"
  entries_normal = entries
else
  entries_normal = entries.reject { |entry| entry.start_with? '.' }
end

MAX_COLUMS = 3

columns = each_slice_into_rows(entries_normal, MAX_COLUMS)

padded_columns = pad_to_max_length(columns)

WIDTH = 18

padded_columns.transpose.each {|row| puts row.map {|entry| hankaku_ljust(entry, WIDTH) }.join }
