# frozen_string_literal: true

require 'optparse'
require 'etc'
require 'date'
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
    entry_paths = entries.map { |entry| File.join(argument, entry) }
  elsif File.file? argument
    entry_paths = [argument]
  else
    puts "ls: \'#{ARGV[0]}\' にアクセスできません: そのようなファイルやディレクトリはありません"
    exit
  end

  if File.directory? argument
    total_blocks = entry_paths.each.sum { |entry_path| File.lstat(entry_path).blocks / BLOCK_SIZE_ADJUSTMENT }
    puts "合計 #{total_blocks}"
  end

  entry_paths.each do |entry_path|
    entry_lstat = File.lstat(entry_path)
    print "#{convert_mode(entry_lstat)} "
    print "#{entry_lstat.nlink} "
    print "#{convert_uid(entry_lstat)} "
    print "#{convert_gid(entry_lstat)} "
    print "#{entry_lstat.size} "
    print "#{convert_mtime(entry_lstat)} "
    puts File.symlink?(entry_path) ? "#{File.basename(entry_path)} -> #{File.readlink(entry_path)}" : File.basename(entry_path)
  end
end

def filter_directory_entries(argument)
  raw_entries = Dir.entries(argument).sort_by(&:downcase)
  raw_entries.reject { |entry| entry.start_with? '.' }
end

def convert_mode(entry_lstat)
  mode = entry_lstat.mode.to_s(8)
  mode = convert_filetype(mode)
  convert_right(mode)
end

def convert_filetype(mode)
  mode = mode.rjust(6, '0')
  mode = mode.gsub(/^01/, 'p')
  mode = mode.gsub(/^02/, 'c')
  mode = mode.gsub(/^04/, 'd')
  mode = mode.gsub(/^06/, 'b')
  mode = mode.gsub(/^10/, '-')
  mode = mode.gsub(/^12/, 'l')
  mode.gsub(/^14/, 's')
end

def convert_right(mode)
  mode = convert_user_right(mode)
  mode = convert_group_right(mode)
  mode = convert_etc_right(mode)
  convert_special_right(mode)
end

def convert_special_right(mode)
  if /^(.)1/.match?(mode)
    mode = mode.gsub(/-$/, 'T')
    mode = mode.gsub(/x$/, 't')
  elsif /^(.)2/ =~ mode || /^(.)3/ =~ mode
    mode = mode.gsub(/-$/, 'S')
    mode = mode.gsub(/x$/, 's')
  end

  mode.gsub(/^(.)\d/, '\1')
end

def convert_user_right(mode)
  mode = mode.gsub(/0(..)$/, '---\1')
  mode = mode.gsub(/1(..)$/, '--x\1')
  mode = mode.gsub(/2(..)$/, '-w-\1')
  mode = mode.gsub(/3(..)$/, '-wx\1')
  mode = mode.gsub(/4(..)$/, 'r--\1')
  mode = mode.gsub(/5(..)$/, 'r-x\1')
  mode = mode.gsub(/6(..)$/, 'rw-\1')
  mode.gsub(/7(..)$/, 'rwx\1')
end

def convert_group_right(mode)
  mode = mode.gsub(/0(.)$/, '---\1')
  mode = mode.gsub(/1(.)$/, '--x\1')
  mode = mode.gsub(/2(.)$/, '-w-\1')
  mode = mode.gsub(/3(.)$/, '-wx\1')
  mode = mode.gsub(/4(.)$/, 'r--\1')
  mode = mode.gsub(/5(.)$/, 'r-x\1')
  mode = mode.gsub(/6(.)$/, 'rw-\1')
  mode.gsub(/7(.)$/, 'rwx\1')
end

def convert_etc_right(mode)
  mode = mode.gsub(/0$/, '---')
  mode = mode.gsub(/1$/, '--x')
  mode = mode.gsub(/2$/, '-w-')
  mode = mode.gsub(/3$/, '-wx')
  mode = mode.gsub(/4$/, 'r--')
  mode = mode.gsub(/5$/, 'r-x')
  mode = mode.gsub(/6$/, 'rw-')
  mode.gsub(/7$/, 'rwx')
end

def convert_uid(entry_lstat)
  user_id = entry_lstat.uid
  Etc.getpwuid(user_id).name
end

def convert_gid(entry_lstat)
  group_id = entry_lstat.gid
  Etc.getgrgid(group_id).name
end

def convert_mtime(entry_lstat)
  mtime = entry_lstat.mtime
  if Date.parse(mtime.to_s) > Date.today << 6
    mtime.strftime('%b %d %H:%M')
  else
    mtime.strftime('%b %d %Y')
  end
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
