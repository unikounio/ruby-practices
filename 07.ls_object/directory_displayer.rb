# frozen_string_literal: true

require_relative 'entry'
require 'debug'

class DirectoryDisplayer
  BLOCK_SIZE_ADJUSTMENT = 2
  MAX_COLUMNS = 3
  WIDTH = 18

  def initialize(directory_path)
    entry_paths = Dir.entries(directory_path).sort_by(&:downcase)
    @entries = entry_paths.map do |relative_path|
      absolute_path = File.join(directory_path, relative_path)
      Entry.new(absolute_path)
    end
  end

  def filter
    @entries.reject!(&:secret?)
  end

  def reverse
    @entries.reverse!
  end

  def display_long
    @entries.each(&:format_long)
    total_blocks = @entries.each.sum { |entry| entry.lstat.blocks / BLOCK_SIZE_ADJUSTMENT }
    puts "total #{total_blocks}"
    padding_statuses
    @entries.each do |entry|
      entry.update_long_format
      puts entry.long_format
    end
  end

  def display_short
    columns = @entries.each_slice((@entries.length.to_f / MAX_COLUMNS).ceil).to_a
    max_length = columns.map(&:length).max
    padded_columns = columns.map { |column| column + [''] * (max_length - column.length) }
    padded_columns.transpose.each do |row|
      padded_row =
        row.map do |entry|
          entry_name =
            if entry == ''
              ''
            else
              entry.name
            end
          hankaku_ljust(entry_name, WIDTH)
        end
      puts padded_row.join
    end
  end

  private

  def padding_statuses
    nlinks_max_length = @entries.map { |entry| entry.nlink.to_s.length }.max
    uids_max_length = @entries.map { |entry| entry.uid.length }.max
    gids_max_length = @entries.map { |entry| entry.gid.length }.max
    sizes_max_length = @entries.map { |entry| entry.size.to_s.length }.max
    year_or_times_max_length = @entries.map { |entry| entry.year_or_time.length }.max
    # 各エントリに対してパディングを適用
    @entries.each do |entry|
      entry.nlink = entry.nlink.to_s.rjust(nlinks_max_length)
      entry.uid = entry.uid.ljust(uids_max_length)
      entry.gid = entry.gid.ljust(gids_max_length)
      entry.size = entry.size.to_s.rjust(sizes_max_length)
      entry.year_or_time = entry.year_or_time.rjust(year_or_times_max_length)
    end
  end

  def hankaku_ljust(entry_name, width, padding = ' ')
    convert_hankaku = entry_name.each_char.sum { |char| char.bytesize > 1 ? (char.bytesize - 2) : 0 }
    entry_name.ljust(width - convert_hankaku, padding)
  end
end
