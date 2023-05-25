# frozen_string_literal: true

require 'optparse'
require 'debug'

BLOCK_SIZE = 1024
MAX_COLUMNS = 3
WIDTH = 18

def main
  option = define_option

  argument = ARGV[0] || '.'

  if option.include?('-l')
    list(argument)
  elsif File.directory? argument
    display_directory_entries(argument)
  elsif File.file? argument
    puts ARGV[0]
  else
    puts "ls: \'#{ARGV[0]}\' にアクセスできません: そのようなファイルやディレクトリはありません"
  end
end

def define_option
  opt = OptionParser.new
  option = []
  opt.on('-l') { option << '-l' } # 今後のオプション追加に備えて、['-l']の代入ではなく空配列への追加という形をとっている。
  opt.parse!(ARGV)
  option
end

def list(argument)
  entries_stat = create_entries_stat(argument)
  puts "合計 #{calculate_blocks(entries_stat)}" if File.directory? argument
  #エントリーごとに詳細情報表示。末尾改行
end

def create_entries_stat(argument)
  if File.directory? argument
    entries = filter_directory_entries(argument)
    entries.map { |entry| File::Stat.new(argument + '/' + entry) }
  elsif File.file? argument
    [File::Stat.new(argument)]
  else
    puts "ls: \'#{ARGV[0]}\' にアクセスできません: そのようなファイルやディレクトリはありません"
    exit
  end
end

def calculate_blocks(entries_stat)
  entries_stat.each.sum { |entry_stat| (entry_stat.blksize.to_f / BLOCK_SIZE ).ceil }
end

def filter_directory_entries(argument)
  raw_entries = Dir.entries(argument).sort { |a, b| a.downcase <=> b.downcase }
  raw_entries.reject { |entry| entry.start_with? '.' }
end

def display_directory_entries(argument)
  entries = filter_directory_entries(argument)
  columns = entries.each_slice((entries.length.to_f / MAX_COLUMNS).ceil).to_a
  max_length = columns.map(&:length).max
  padded_columns = columns.map { |column| column + [''] * (max_length - column.length) }
  padded_columns.transpose.each do |row|
    puts row.map { |entry| hankaku_ljust(entry, WIDTH) }.join
  end
end

def hankaku_ljust(string, width, padding = ' ')
  convert_hankaku = string.each_char.sum { |char| char.bytesize > 1 ? (char.bytesize - 2) : 0 }
  string.ljust(width - convert_hankaku, padding)
end

main
