# frozen_string_literal: true

require 'optparse'

MAX_COLUMNS = 3
WIDTH = 18

opt = OptionParser.new
option = []
opt.on('-a') { option << '-a' } # 今後のオプション追加に備えて、['-a']の代入ではなく空配列への追加という形をとっている。
opt.parse!(ARGV)

argument = ARGV[0] || '.'

if File.directory? argument
  entries = Dir.entries(argument).sort
elsif File.file? argument
  puts ARGV[0]
else
  puts "ls: \'#{ARGV[0]}\' にアクセスできません: そのようなファイルやディレクトリはありません"
end

exit unless File.directory? argument

def exclude_hidden_entries(option, entries)
  if option.include? '-a'
    entries
  else
    entries.reject { |entry| entry.start_with? '.' }
  end
end

def hankaku_ljust(string, width, padding = ' ')
  convert_hankaku = string.each_char.sum { |char| char.bytesize > 1 ? (char.bytesize - 2) : 0 }
  string.ljust(width - convert_hankaku, padding)
end

visible_entries = exclude_hidden_entries(option, entries)

columns = visible_entries.each_slice((visible_entries.length.to_f / MAX_COLUMNS).ceil).to_a

max_length = columns.map(&:length).max

padded_columns = columns.map { |column| column + [''] * (max_length - column.length) }

padded_columns.transpose.each do |row|
  puts row.map { |entry| hankaku_ljust(entry, WIDTH) }.join
end
