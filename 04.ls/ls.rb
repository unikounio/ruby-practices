# frozen_string_literal: true

require 'optparse'
require 'etc'
require 'date'

BLOCK_SIZE_ADJUSTMENT = 2
MAX_COLUMNS = 3
WIDTH = 18

def main
  option = define_option

  argument = ARGV[0] || '.'

  if option.include?('-l')
    format_long(argument)
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

def format_long(argument)
  if File.directory? argument
    entry_paths = filter_directory_entries(argument).map { |entry| File.join(argument, entry) }
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

  display_long_entries(entry_paths)
end

def display_long_entries(entry_paths)
  entry_lstats = entry_paths.map { |entry_path| File.lstat(entry_path) }
  entry_modes = entry_lstats.map do |entry_lstat|
    entry_mode = convert_filetype(entry_lstat.mode.to_s(8))
    convert_right(entry_mode)
  end
  entry_basenames = entry_paths.map do |entry_path|
    File.symlink?(entry_path) ? "#{File.basename(entry_path)} -> #{File.readlink(entry_path)}" : File.basename(entry_path)
  end
  entry_statuses = [entry_modes, shape_entry_nlinks(entry_lstats), shape_entry_uids(entry_lstats), shape_entry_gids(entry_lstats),
                    shape_entry_sizes(entry_lstats), shape_entry_mtimes(entry_lstats), entry_basenames]
  entry_statuses.transpose.each do |long_entry|
    puts long_entry.join(' ')
  end
end

def shape_entry_nlinks(entry_lstats)
  entry_nlinks = entry_lstats.map { |entry_lstat| entry_lstat.nlink.to_s }
  padding_informations_rjust(entry_nlinks)
end

def shape_entry_uids(entry_lstats)
  entry_username = entry_lstats.map { |entry_lstat| Etc.getpwuid(entry_lstat.uid).name }
  padding_informations_ljust(entry_username)
end

def shape_entry_gids(entry_lstats)
  entry_groupname = entry_lstats.map { |entry_lstat| Etc.getgrgid(entry_lstat.gid).name }
  padding_informations_ljust(entry_groupname)
end

def shape_entry_sizes(entry_lstats)
  entry_sizes = entry_lstats.map { |entry_lstat| entry_lstat.size.to_s }
  padding_informations_rjust(entry_sizes)
end

def padding_informations_rjust(entry_informations)
  entry_informations.map do |entry_information|
    entry_information.rjust(entry_informations.map(&:length).max)
  end
end

def padding_informations_ljust(entry_informations)
  entry_informations.map do |entry_information|
    entry_information.ljust(entry_informations.map(&:length).max)
  end
end

def filter_directory_entries(argument)
  raw_entries = Dir.entries(argument).sort_by(&:downcase)
  raw_entries.reject { |entry| entry.start_with? '.' }
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

def shape_entry_mtimes(entry_lstats)
  entry_mtimes = entry_lstats.map(&:mtime)
  months_and_days = entry_mtimes.map { |entry_mtime| entry_mtime.strftime('%b %e') }
  years_or_times = entry_mtimes.map do |entry_mtime|
    if Date.parse(entry_mtime.to_s) > Date.today << 6
      entry_mtime.strftime('%H:%M')
    else
      entry_mtime.strftime('%Y')
    end
  end
  padded_entry_mtimes = [months_and_days, padding_informations_rjust(years_or_times)].transpose
  padded_entry_mtimes.map { |padded_entry_mtime| padded_entry_mtime.join(' ') }
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
