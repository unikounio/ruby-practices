# frozen_string_literal: true

require 'optparse'
require 'pathname'
require_relative 'directory_displayer'
require_relative 'entry'

def main
  options = parse_options

  pathname = Pathname(ARGV[0] || '.')

  if options[:long_format] && file_or_directory?(pathname)
    run_ls_long(pathname, options)
  elsif file_or_directory?(pathname)
    run_ls_short(pathname, options)
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

def run_ls_long(pathname, options)
  if pathname.directory?
    display_directory(pathname, options, :display_long)
  elsif pathname.file?
    entry = Entry.new(pathname)
    entry.setup_long_format
    puts entry.build_long_format
  end
end

def run_ls_short(pathname, options)
  if pathname.directory?
    display_directory(pathname, options, :display_short)
  elsif pathname.file?
    puts pathname.basename
  end
end

def display_directory(pathname, options, display_method)
  directory_displayer = build_directory_displayer(pathname, options)

  display_method == :display_long ? directory_displayer.display_long : directory_displayer.display_short
end

def build_directory_displayer(pathname, options)
  directory_displayer = DirectoryDisplayer.new(pathname)
  directory_displayer.filter unless options[:dot_match]
  directory_displayer.reverse if options[:reverse]
  directory_displayer
end

main
