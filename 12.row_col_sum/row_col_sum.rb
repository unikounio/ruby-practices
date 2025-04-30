def row_col_sum(input)
  result = input.map do |row|
    row_total = row.sum
    [*row, row_total]
  end

  col_totals = result.transpose.map(&:sum)

  [*result, col_totals]
end
