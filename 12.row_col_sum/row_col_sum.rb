def row_col_sum(input)
  result = input.map do |row|
    row_total = row.sum
    [*row, row_total]
  end

  col_totals = result.transpose.map do |col|
    col.sum
  end

  [*result, col_totals]
end
