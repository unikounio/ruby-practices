# frozen_string_literal: true

require 'optparse'
require 'pathname'
require_relative 'entries_displayer'
require_relative 'entry'

class LsCommand
  def run
    options = parse_options

    pathname = Pathname(ARGV[0] || '.')

    if options[:long_format] && file_or_directory?(pathname)
      display_long_format(pathname, options)
    elsif file_or_directory?(pathname)
      display_short_format(pathname, options)
    else
      puts "ls: cannot access \'#{ARGV[0]}\': No such file or directory"
    end
  end

  private

  def parse_options
    opt = OptionParser.new
    options = { long_format: false, reverse: false, dot_match: false }
    opt.on('-l') { |v| options[:long_format] = v }
    opt.on('-r') { |v| options[:reverse] = v }
    opt.on('-a') { |v| options[:dot_match] = v }
    opt.parse!(ARGV)
    options
  end

  def file_or_directory?(pathname)
    pathname.directory? || pathname.file?
  end

  def display_long_format(pathname, options)
    if pathname.directory?
      display_directory(pathname, options, :display_long)
    elsif pathname.file?
      entry = Entry.new(pathname)
      entries_displayer = EntriesDisplayer.new([entry])
      entries_displayer.display_long_entries
    end
  end

  def display_short_format(pathname, options)
    if pathname.directory?
      display_directory(pathname, options, :display_short)
    elsif pathname.file?
      puts pathname.basename
    end
  end

  def display_directory(pathname, options, display_method)
    entries_displayer = build_entries_displayer(pathname, options)

    display_method == :display_long ? entries_displayer.display_long : entries_displayer.display_short
  end

  def build_entries_displayer(pathname, options)
    entry_paths = Dir.entries(pathname).sort_by(&:downcase)
    entries = entry_paths.map do |relative_path|
      absolute_path = File.join(pathname, relative_path)
      Entry.new(absolute_path)
    end

    EntriesDisplayer.new(entries, options)
  end
end
