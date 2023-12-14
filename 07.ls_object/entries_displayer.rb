# frozen_string_literal: true

require_relative 'entry'

class EntriesDisplayer
  BLOCK_SIZE_ADJUSTMENT = 2
  MAX_COLUMNS = 3

  def initialize(entries, options = {})
    entries.reject!(&:secret?) unless options[:dot_match]
    entries.reverse! if options[:reverse]
    @entries = entries
  end

  def display_long
    display_total_blocks
    display_long_entries
  end

  def display_long_entries
    nlinks_max_length = measure_max_length(:nlink)
    uids_max_length = measure_max_length(:uid)
    gids_max_length = measure_max_length(:gid)
    sizes_max_length = measure_max_length(:size)
    years_or_times_max_length = measure_max_length(:year_or_time)
    @entries.each do |entry|
      padded_nlink = entry.nlink.rjust(nlinks_max_length)
      padded_uid = entry.uid.ljust(uids_max_length)
      padded_gid = entry.gid.ljust(gids_max_length)
      padded_size = entry.size.rjust(sizes_max_length)
      padded_year_or_time = entry.year_or_time.rjust(years_or_times_max_length)
      puts [entry.mode, padded_nlink, padded_uid, padded_gid, padded_size, entry.month_and_day, padded_year_or_time, entry.basename].join(' ')
    end
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

  def measure_max_length(attribute)
    allowed_methods = %i[nlink uid gid size year_or_time]
    raise "Method `#{attribute}' is not allowed." unless allowed_methods.include?(attribute)

    @entries.map { |entry| entry.public_send(attribute).to_s.length }.max
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
    max_bytesize = @entries.map { |entry| measure_bytesize(entry.name) }.max

    row.map do |entry|
      entry_name =
        entry == '' ? '' : entry.name
      display_width = max_bytesize + 1
      entry_name.ljust(display_width, ' ')
    end
  end

  def measure_bytesize(entry_name)
    entry_name.each_char.sum do |char|
      char.bytesize == 1 ? 1 : 2
    end
  end
end
