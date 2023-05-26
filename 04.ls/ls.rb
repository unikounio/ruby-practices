# frozen_string_literal: true

require 'optparse'
require 'debug'

BLOCK_SIZE_ADJUSTMENT = 2
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
  if File.directory? argument
    entries = filter_directory_entries(argument)
    entries_path = entries.map{ |entry| argument + '/' + entry }
  elsif File.file? argument
    entries = [argument]
  else
    puts "ls: \'#{ARGV[0]}\' にアクセスできません: そのようなファイルやディレクトリはありません"
    exit
  end

  if File.directory? argument
    total_blocks = entries_path.each.sum { |entry_path| File.lstat(entry_path).blocks / BLOCK_SIZE_ADJUSTMENT }
    puts "合計 #{total_blocks}"
  end

  entries_path.each do |entry_path|
    print "#{analyze_mode(entry_path)} "
    print "#{File.lstat(entry_path).nlink} "
    print "#{File.lstat(entry_path).uid} "
    print "#{File.lstat(entry_path).gid} "
    print "#{File.lstat(entry_path).size} "
    print "#{File.lstat(entry_path).mtime} "
    puts File.symlink?(entry_path) ? "#{File.basename(entry_path)} -> #{File.readlink(entry_path)}" : File.basename(entry_path)
  end
end

def analyze_mode(entry)
  File.lstat(entry).mode
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
