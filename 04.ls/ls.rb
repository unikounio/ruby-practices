# frozen_string_literal: true

require 'optparse'
require 'etc'
require 'date'

BLOCK_SIZE_ADJUSTMENT = 2
MODE_LENGTH = 6
MAX_COLUMNS = 3
WIDTH = 18

def main
  options = define_options

  argument = ARGV[0] || '.'

  if options.include?('-l')
    format_long(argument, options)
  elsif File.directory? argument
    display_directory_entries(argument, options)
  elsif File.file? argument
    puts ARGV[0]
  else
    puts "ls: \'#{ARGV[0]}\' にアクセスできません: そのようなファイルやディレクトリはありません"
  end
end

def define_options
  opt = OptionParser.new
  options = []
  opt.on('-a') { options << '-a' }
  opt.on('-r') { options << '-r' }
  opt.on('-l') { options << '-l' }
  opt.parse!(ARGV)
  options
end

def format_long(argument, options)
  if File.directory? argument
    entry_paths = filter_and_sort_entries(argument, options).map { |entry| File.join(argument, entry) }
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
    mode = entry_lstat.mode.to_s(8).rjust(MODE_LENGTH, '0')
    "#{convert_filetype(mode)}#{convert_permissions(mode)}"
  end
  entry_basenames = entry_paths.map do |entry_path|
    File.symlink?(entry_path) ? "#{File.basename(entry_path)} -> #{File.readlink(entry_path)}" : File.basename(entry_path)
  end
  entry_statuses =
    [entry_modes, shape_entry_nlinks(entry_lstats), shape_entry_uids(entry_lstats), shape_entry_gids(entry_lstats),
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

def filter_and_sort_entries(argument, options)
  raw_entries = Dir.entries(argument).sort_by(&:downcase)
  filtered_entries = options.include?('-a') ? raw_entries : raw_entries.reject { |raw_entry| raw_entry.start_with? '.' }
  options.include?('-r') ? filtered_entries.reverse : filtered_entries
end

def convert_filetype(mode)
  filetype = {
    '01' => 'p',
    '02' => 'c',
    '04' => 'd',
    '06' => 'b',
    '10' => '-',
    '12' => '1',
    '14' => 's'
  }
  filetype[mode[0..1]]
end

def convert_permissions(mode)
  permission_pattern = {
    '0' => '---',
    '1' => '--x',
    '2' => '-w-',
    '3' => '-wx',
    '4' => 'r--',
    '5' => 'r-x',
    '6' => 'rw-',
    '7' => 'rwx'
  }
  permissions = mode.gsub(/\d{3}$/) do |raw_permissions|
    raw_permissions.gsub(/\d/, permission_pattern)
  end
  convert_special_permission(permissions)[3..11]
end

def convert_special_permission(permissions)
  case permissions[2]
  when '1'
    permissions.gsub(/.$/, { '-' => 'T', 'x' => 't' })
  when '2', '3'
    permissions.gsub(/.$/, { '-' => 'S', 'x' => 's' })
  else
    permissions
  end
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

def display_directory_entries(argument, options)
  entries = filter_and_sort_entries(argument, options)
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
