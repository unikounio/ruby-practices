# frozen_string_literal: true

argument = ARGV[0].nil? ? '.' : ARGV[0]

if File.directory? argument
  entries = Dir.entries(argument).sort
elsif File.file? argument
  puts ARGV[0]
else
  puts "ls: \'#{ARGV[0]}\' にアクセスできません: そのようなファイルやディレクトリはありません"
end

exit unless File.directory? argument

# -aオプションの場合はこの処理を省く必要がありそうなので、entriesとは別の変数として定義している
entries_normal = entries.reject { |entry| entry.start_with? '.' }

public

def each_slice_into_rows(max_columns)
  each_slice((length.to_f / max_columns).ceil)
end

columns = entries_normal.each_slice_into_rows(3).to_a

def pad_to_max_length
  map { |array| array + [''] * (map(&:length).max - array.length) }
end

padded_columns = columns.pad_to_max_length

def hankaku_ljust(width, padding = ' ')
  convert_hankaku = 0

  each_char do |char|
    convert_hankaku += char.bytesize - 2 if char.bytesize > 1
  end

  ljust(width - convert_hankaku, padding)
end

padded_columns.transpose.each do |row|
  row.each do |entry|
    print entry.hankaku_ljust(18)
  end

  puts
end
