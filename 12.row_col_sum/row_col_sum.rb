input = [
    [9, 85, 92, 20],
    [68, 25, 80, 55],
    [43, 96, 71, 73],
    [43, 19, 20, 87],
    [95, 66, 73, 62]
]

result = input.map do |row|
  row_total = row.sum
  row << row_total
end

col_totals = []
result.transpose.each do |col|
  col_totals << col.sum
end

result << col_totals
