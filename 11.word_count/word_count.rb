text = <<TEXT
Ruby is an interpreted, high-level, general-purpose programming language. It was designed with an emphasis on programming productivity and simplicity. In Ruby, everything is an object, including primitive data types. It was developed in the mid-1990s by Yukihiro "Matz" Matsumoto in Japan.

Ruby is dynamically typed and uses garbage collection and just-in-time compilation. It supports multiple programming paradigms, including procedural, object-oriented, and functional programming. According to the creator, Ruby was influenced by Perl, Smalltalk, Eiffel, Ada, BASIC, Java, and Lisp.
TEXT

arr = text.scan(/[A-Za-z0-9-]+/)
arr2 = arr.map do |s|
  s.downcase
end

h = {}
arr2.each do |s|
  if h.key?(s)
    h[s] = h[s] + 1
  else
    h[s] = 1
  end
end

sorted_h = h.sort_by {|key, value| value }.reverse.to_h

sorted_h.each do |key, value|
  puts "#{key}：#{value}回"
end
