def row_col_sum(input)
  result = input.map do |row|
    row_copy = row.clone
    row_total = row.sum
    row_copy << row_total
  end

  col_totals = result.transpose.map do |col|
    col.sum
  end

  result << col_totals
end
