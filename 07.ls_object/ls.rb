# frozen_string_literal: true

require 'optparse'
require 'pathname'
require_relative 'directory_displayer'
require_relative 'entry'

def main
  options = define_options

  pathname = Pathname(ARGV[0] || '.')

  if options[:long_format]
    run_ls_long(pathname, options)
  elsif pathname.directory? || pathname.file?
    run_ls_short(pathname, options)
  else
    puts "ls: cannot access \'#{ARGV[0]}\': No such file or directory"
  end
end

private

def define_options
  opt = OptionParser.new
  options = { long_format: false, reverse: false, dot_match: false }
  opt.on('-l') { |v| options[:long_format] = v }
  opt.on('-r') { |v| options[:reverse] = v }
  opt.on('-a') { |v| options[:dot_match] = v }
  opt.parse!(ARGV)
  options
end

def run_ls_long(pathname, options)
  if pathname.directory?
    directory = create_directory(pathname, options)
    directory.display_long
  elsif pathname.file?
    entry = Entry.new(pathname)
    entry.format_long
    puts entry.long_format
  end
end

def run_ls_short(pathname, options)
  if pathname.directory?
    directory = create_directory(pathname, options)
    directory.display_short
  elsif pathname.file?
    puts pathname.basename
  end
end

def create_directory(pathname, options)
  directory = DirectoryDisplayer.new(pathname)
  directory.filter unless options[:dot_match]
  directory.reverse if options[:reverse]
  directory
end

main
