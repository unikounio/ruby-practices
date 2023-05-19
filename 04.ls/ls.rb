# frozen_string_literal: true

require 'optparse'

MAX_COLUMNS = 3
WIDTH = 18

def main
  option = define_option

  argument = ARGV[0] || '.'

  entries = categorize_entry(option, argument)

  exit unless File.directory? argument

  columns = entries.each_slice((entries.length.to_f / MAX_COLUMNS).ceil).to_a
  max_length = columns.map(&:length).max
  padded_columns = columns.map { |column| column + [''] * (max_length - column.length) }
  padded_columns.transpose.each do |row|
    puts row.map { |entry| hankaku_ljust(entry, WIDTH) }.join
  end
end

def define_option
  opt = OptionParser.new
  option = []
  opt.on('-r') { option << '-r' } # 今後のオプション追加に備えて、['-r']の代入ではなく空配列への追加という形をとっている。
  opt.parse!(ARGV)
  option
end

def categorize_entry(option, argument)
  if File.directory? argument
    filter_directory_entries(option, argument)
  elsif File.file? argument
    puts ARGV[0]
  else
    puts "ls: \'#{ARGV[0]}\' にアクセスできません: そのようなファイルやディレクトリはありません"
  end
end

def filter_directory_entries(option, argument)
  raw_entries = Dir.entries(argument).sort
  filtered_entries = raw_entries.reject { |entry| entry.start_with? '.' }
  option.include?('-r') ? filtered_entries.reverse : filtered_entries
end

def hankaku_ljust(string, width, padding = ' ')
  convert_hankaku = string.each_char.sum { |char| char.bytesize > 1 ? (char.bytesize - 2) : 0 }
  string.ljust(width - convert_hankaku, padding)
end

main
