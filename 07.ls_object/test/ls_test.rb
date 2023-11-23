# frozen_string_literal: true

require 'test/unit'
require 'stringio'
require_relative '../ls'

class LsTest < Test::Unit::TestCase
  def setup
    ARGV.replace(['./test/sample'])
    $stdout = StringIO.new
  end

  def test_long_format_directory
    ARGV.push('-l')
    text = <<~ENTRIES
      total 20
      drwxr-xr-x 2 unikounio unikounio 4096 Nov 23 22:56 directory
      -rw-r--r-- 1 unikounio unikounio    7 Nov 23 22:53 sample1.txt
      -rw-r--r-- 1 unikounio unikounio   17 Nov 23 22:56 sample3.txt
      -rw-r--r-- 1 unikounio unikounio   13 Nov 23 23:02 sample4.txt
      -rw-r--r-- 1 unikounio unikounio   13 Nov 23 23:02 sample5.txt
    ENTRIES
    main
    assert_equal text, $stdout.string
  end

  def test_long_format_directory_with_dotmatch
    ARGV.push('-l', '-a')
    text = <<~ENTRIES
      total 32
      drwxr-xr-x 3 unikounio unikounio 4096 Nov 23 23:02 .
      drwxr-xr-x 3 unikounio unikounio 4096 Nov 23 22:51 ..
      -rw-r--r-- 1 unikounio unikounio   16 Nov 23 22:56 .sample2.txt
      drwxr-xr-x 2 unikounio unikounio 4096 Nov 23 22:56 directory
      -rw-r--r-- 1 unikounio unikounio    7 Nov 23 22:53 sample1.txt
      -rw-r--r-- 1 unikounio unikounio   17 Nov 23 22:56 sample3.txt
      -rw-r--r-- 1 unikounio unikounio   13 Nov 23 23:02 sample4.txt
      -rw-r--r-- 1 unikounio unikounio   13 Nov 23 23:02 sample5.txt
    ENTRIES
    main
    assert_equal text, $stdout.string
  end

  def test_long_format_directory_with_reverse
    ARGV.push('-l', '-r')
    text = <<~ENTRIES
      total 20
      -rw-r--r-- 1 unikounio unikounio   13 Nov 23 23:02 sample5.txt
      -rw-r--r-- 1 unikounio unikounio   13 Nov 23 23:02 sample4.txt
      -rw-r--r-- 1 unikounio unikounio   17 Nov 23 22:56 sample3.txt
      -rw-r--r-- 1 unikounio unikounio    7 Nov 23 22:53 sample1.txt
      drwxr-xr-x 2 unikounio unikounio 4096 Nov 23 22:56 directory
    ENTRIES
    main
    assert_equal text, $stdout.string
  end

  def test_long_format_directory_with_all_options
    ARGV.push('-l', '-a', '-r')
    text = <<~ENTRIES
      total 32
      -rw-r--r-- 1 unikounio unikounio   13 Nov 23 23:02 sample5.txt
      -rw-r--r-- 1 unikounio unikounio   13 Nov 23 23:02 sample4.txt
      -rw-r--r-- 1 unikounio unikounio   17 Nov 23 22:56 sample3.txt
      -rw-r--r-- 1 unikounio unikounio    7 Nov 23 22:53 sample1.txt
      drwxr-xr-x 2 unikounio unikounio 4096 Nov 23 22:56 directory
      -rw-r--r-- 1 unikounio unikounio   16 Nov 23 22:56 .sample2.txt
      drwxr-xr-x 3 unikounio unikounio 4096 Nov 23 22:51 ..
      drwxr-xr-x 3 unikounio unikounio 4096 Nov 23 23:02 .
    ENTRIES
    main
    assert_equal text, $stdout.string
  end

  def test_long_format_file
    path = [ARGV, 'sample1.txt'].join('/')
    ARGV.replace([path, '-l'])
    text = "-rw-r--r-- 1 unikounio unikounio 7 Nov 23 22:53 sample1.txt\n"
    main
    assert_equal text, $stdout.string
  end

  def test_short_format_directory
    text = <<~ENTRIES
      directory         sample3.txt       sample5.txt       
      sample1.txt       sample4.txt                         
    ENTRIES
    main
    assert_equal text, $stdout.string
  end

  def test_short_format_directory_with_dotmatch
    ARGV.push('-a')
    text = <<~ENTRIES
      .                 directory         sample4.txt       
      ..                sample1.txt       sample5.txt       
      .sample2.txt      sample3.txt                         
    ENTRIES
    main
    assert_equal text, $stdout.string
  end

  def test_short_format_directory_with_reverse
    ARGV.push('-r')
    text = <<~ENTRIES
      sample5.txt       sample3.txt       directory         
      sample4.txt       sample1.txt                         
    ENTRIES
    main
    assert_equal text, $stdout.string
  end

  def test_short_format_directory_with_dotmatch_and_reverse
    ARGV.push('-a', '-r')
    text = <<~ENTRIES
      sample5.txt       sample1.txt       ..                
      sample4.txt       directory         .                 
      sample3.txt       .sample2.txt                        
    ENTRIES
    main
    assert_equal text, $stdout.string
  end

  def test_short_format_file
    path = [ARGV, 'sample1.txt'].join('/')
    ARGV.replace([path])
    text = "sample1.txt\n"
    main
    assert_equal text, $stdout.string
  end

  def test_No_such_file_or_directory
    path = [ARGV, 'not_exist_entry'].join('/')
    ARGV.replace([path])
    text = "ls: cannot access \'#{ARGV[0]}\': No such file or directory\n"
    main
    assert_equal text, $stdout.string
  end
end
