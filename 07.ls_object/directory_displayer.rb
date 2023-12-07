# frozen_string_literal: true

require_relative 'entry'

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
    @entries.each(&:setup_long_format)
    display_total_blocks
    padding_statuses
    display_long_entries
  end

  def display_short
    padded_columns = create_padded_columns
    display_rows(padded_columns.transpose)
  end

  private

  def display_total_blocks
    total_blocks = @entries.each.sum { |entry| entry.lstat.blocks / BLOCK_SIZE_ADJUSTMENT }
    puts "total #{total_blocks}"
  end

  def padding_statuses
    padding_status(:nlink, :rjust)
    padding_status(:uid, :ljust)
    padding_status(:gid, :ljust)
    padding_status(:size, :rjust)
    padding_status(:year_or_time, :rjust)
  end

  def padding_status(attribute, padding_method)
    allowed_methods = [:nlink, :uid, :gid, :size, :year_or_time]
    unless allowed_methods.include?(attribute)
      raise RuntimeError, "Method `#{attribute}' is not allowed."
    end

    max_length = @entries.map { |entry| entry.public_send(attribute).to_s.length }.max
    @entries.each do |entry|
      status = entry.public_send(attribute).to_s
      padded_status = status.public_send(padding_method, max_length)
      entry.public_send("#{attribute}=", padded_status)
    end
  end

  def display_long_entries
    @entries.each do |entry|
      puts entry.build_long_format
    end
  end

  def create_padded_columns
    columns = @entries.each_slice((@entries.length.to_f / MAX_COLUMNS).ceil).to_a
    max_length = columns.map(&:length).max
    columns.map { |column| column + [''] * (max_length - column.length) }
  end

  def display_rows(rows)
    rows.each do |row|
      padded_row = padding_entries(row)
      puts padded_row.join
    end
  end

  def padding_entries(row)
    row.map do |entry|
      entry_name =
        entry == '' ? '' : entry.name
      display_width = WIDTH - measure_bytesize(entry_name)
      entry_name.ljust(display_width, ' ')
    end
  end

  def measure_bytesize(entry_name)
    entry_name.each_char.sum do |char|
      char.bytesize > 1 ? (char.bytesize - 2) : 0
    end
  end
end
