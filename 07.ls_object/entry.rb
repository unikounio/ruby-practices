# frozen_string_literal: true

require 'etc'
require 'date'

class Entry
  MODE_LENGTH = 6
  FILETYPE = {
    '01' => 'p',
    '02' => 'c',
    '04' => 'd',
    '06' => 'b',
    '10' => '-',
    '12' => '1',
    '14' => 's'
  }.freeze

  PERMISSION_PATTERN = {
    '0' => '---',
    '1' => '--x',
    '2' => '-w-',
    '3' => '-wx',
    '4' => 'r--',
    '5' => 'r-x',
    '6' => 'rw-',
    '7' => 'rwx'
  }.freeze

  attr_reader :path, :name

  def initialize(path)
    @path = path
    @name = File.basename(path)
  end

  def secret?
    name.start_with? '.'
  end

  def lstat
    File.lstat(path)
  end

  def mode
    raw_mode = lstat.mode.to_s(8).rjust(MODE_LENGTH, '0')
    [FILETYPE[raw_mode[0..1]], convert_permissions(raw_mode)].join
  end

  def nlink
    lstat.nlink.to_s
  end

  def uid
    Etc.getpwuid(lstat.uid).name
  end

  def gid
    Etc.getgrgid(lstat.gid).name
  end

  def size
    lstat.size.to_s
  end

  def month_and_day
    mtime.strftime('%b %e')
  end

  def year_or_time
    if Date.parse(mtime.to_s) > Date.today << 6
      mtime.strftime('%H:%M')
    else
      mtime.strftime('%Y')
    end
  end

  def basename
    File.symlink?(path) ? "#{File.basename(path)} -> #{File.readlink(path)}" : File.basename(path)
  end

  private

  def convert_permissions(raw_mode)
    permissions = raw_mode.gsub(/\d{3}$/) do |raw_permissions|
      raw_permissions.gsub(/\d/, PERMISSION_PATTERN)
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

  def mtime
    lstat.mtime
  end
end
