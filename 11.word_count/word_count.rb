text = <<TEXT
Ruby is an interpreted, high-level, general-purpose programming language. It was designed with an emphasis on programming productivity and simplicity. In Ruby, everything is an object, including primitive data types. It was developed in the mid-1990s by Yukihiro "Matz" Matsumoto in Japan.

Ruby is dynamically typed and uses garbage collection and just-in-time compilation. It supports multiple programming paradigms, including procedural, object-oriented, and functional programming. According to the creator, Ruby was influenced by Perl, Smalltalk, Eiffel, Ada, BASIC, Java, and Lisp.
TEXT

words = text.scan(/[A-Za-z0-9-]+/)
lowercase_words = words.map do |word|
  word.downcase
end

counted_words = lowercase_words.tally

sorted_words = counted_words.sort_by {|word, count| count }.reverse.to_h

sorted_words.each do |word, count|
  puts "#{word}：#{count}回"
end
