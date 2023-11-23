# frozen_string_literal: true

require 'test/unit'
require 'stringio'
require_relative '../ls'

class LsTest < Test::Unit::TestCase
  def setup
    @parent_path = './test/sample'
    $stdout = StringIO.new
  end

  def set_directory_path_to_argv(*options)
    current_path = [@parent_path, 'directory'].join('/')
    options.empty? ? ARGV.replace([current_path]) : ARGV.replace([current_path, options].flatten)
  end

  def set_file_path_to_argv(file_name, option=nil)
    file_path = [@parent_path, file_name].join('/')
    option.nil? ? ARGV.replace([file_path]) : ARGV.replace([file_path, option])
  end

  def test_long_format_directory
    set_directory_path_to_argv('-l')
    text = <<~ENTRIES
      total 20
      drwxr-xr-x 2 unikounio unikounio 4096 Nov 24 00:38 directory1
      -rw-r--r-- 1 unikounio unikounio    7 Nov 24 00:02 sample1.txt
      -rw-r--r-- 1 unikounio unikounio   17 Nov 24 00:02 sample3.txt
      -rw-r--r-- 1 unikounio unikounio   13 Nov 24 00:02 sample4.txt
      -rw-r--r-- 1 unikounio unikounio   13 Nov 24 00:02 sample5.txt
    ENTRIES
    main
    assert_equal text, $stdout.string
  end

  def test_long_format_directory_with_dotmatch
    set_directory_path_to_argv('-l', '-a')
    text = <<~ENTRIES
      total 32
      drwxr-xr-x 3 unikounio unikounio 4096 Nov 24 00:40 .
      drwxr-xr-x 3 unikounio unikounio 4096 Nov 24 00:39 ..
      -rw-r--r-- 1 unikounio unikounio   16 Nov 24 00:02 .sample2.txt
      drwxr-xr-x 2 unikounio unikounio 4096 Nov 24 00:38 directory1
      -rw-r--r-- 1 unikounio unikounio    7 Nov 24 00:02 sample1.txt
      -rw-r--r-- 1 unikounio unikounio   17 Nov 24 00:02 sample3.txt
      -rw-r--r-- 1 unikounio unikounio   13 Nov 24 00:02 sample4.txt
      -rw-r--r-- 1 unikounio unikounio   13 Nov 24 00:02 sample5.txt
    ENTRIES
    main
    assert_equal text, $stdout.string
  end

  def test_long_format_directory_with_reverse
    set_directory_path_to_argv('-l', '-r')
    text = <<~ENTRIES
      total 20
      -rw-r--r-- 1 unikounio unikounio   13 Nov 24 00:02 sample5.txt
      -rw-r--r-- 1 unikounio unikounio   13 Nov 24 00:02 sample4.txt
      -rw-r--r-- 1 unikounio unikounio   17 Nov 24 00:02 sample3.txt
      -rw-r--r-- 1 unikounio unikounio    7 Nov 24 00:02 sample1.txt
      drwxr-xr-x 2 unikounio unikounio 4096 Nov 24 00:38 directory1
    ENTRIES
    main
    assert_equal text, $stdout.string
  end

  def test_long_format_directory_with_all_options
    set_directory_path_to_argv('-l', '-a', '-r')
    text = <<~ENTRIES
      total 32
      -rw-r--r-- 1 unikounio unikounio   13 Nov 24 00:02 sample5.txt
      -rw-r--r-- 1 unikounio unikounio   13 Nov 24 00:02 sample4.txt
      -rw-r--r-- 1 unikounio unikounio   17 Nov 24 00:02 sample3.txt
      -rw-r--r-- 1 unikounio unikounio    7 Nov 24 00:02 sample1.txt
      drwxr-xr-x 2 unikounio unikounio 4096 Nov 24 00:38 directory1
      -rw-r--r-- 1 unikounio unikounio   16 Nov 24 00:02 .sample2.txt
      drwxr-xr-x 3 unikounio unikounio 4096 Nov 24 00:39 ..
      drwxr-xr-x 3 unikounio unikounio 4096 Nov 24 00:40 .
    ENTRIES
    main
    assert_equal text, $stdout.string
  end

  def test_long_format_file
    set_file_path_to_argv('sample1.txt', '-l')
    text = "-rw-r--r-- 1 unikounio unikounio 7 Nov 23 22:53 sample1.txt\n"
    main
    assert_equal text, $stdout.string
  end

  def test_short_format_directory
    set_directory_path_to_argv
    text = <<~ENTRIES
      directory1        sample3.txt       sample5.txt#{'       '}
      sample1.txt       sample4.txt#{'                         '}
    ENTRIES
    main
    assert_equal text, $stdout.string
  end

  def test_short_format_directory_with_dotmatch
    set_directory_path_to_argv('-a')
    ARGV.push('-a')
    text = <<~ENTRIES
      .                 directory1        sample4.txt#{'       '}
      ..                sample1.txt       sample5.txt#{'       '}
      .sample2.txt      sample3.txt#{'                         '}
    ENTRIES
    main
    assert_equal text, $stdout.string
  end

  def test_short_format_directory_with_reverse
    set_directory_path_to_argv('-r')
    text = <<~ENTRIES
      sample5.txt       sample3.txt       directory1#{'        '}
      sample4.txt       sample1.txt#{'                         '}
    ENTRIES
    main
    assert_equal text, $stdout.string
  end

  def test_short_format_directory_with_dotmatch_and_reverse
    set_directory_path_to_argv('-a', '-r')
    text = <<~ENTRIES
      sample5.txt       sample1.txt       ..#{'                '}
      sample4.txt       directory1        .#{'                 '}
      sample3.txt       .sample2.txt#{'                        '}
    ENTRIES
    main
    assert_equal text, $stdout.string
  end

  def test_short_format_file
    set_file_path_to_argv('sample1.txt')
    text = "sample1.txt\n"
    main
    assert_equal text, $stdout.string
  end

  def test_no_such_file_or_directory
    set_file_path_to_argv('not_exist_entry')
    text = "ls: cannot access \'#{ARGV[0]}\': No such file or directory\n"
    main
    assert_equal text, $stdout.string
  end
end
