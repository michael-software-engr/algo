class String
  def palindrome?
    return true if size == 1 || size.zero?

    sanitized_str = sanitize self

    return sanitized_str[1..-2].palindrome? if sanitized_str[0] == sanitized_str[-1]

    return false
  end

  private

  def sanitize(str)
    str.downcase.scan(/\w+/).join
  end
end

[
  ['', true],
  ['z', true],
  ['abcd', false],
  ['abba', true],
  ['Never a foot too far, even.', true],
  ['notapali', false]
].each do |(str, exp)|
  is_palindrome = str.palindrome?
  puts "Str: '#{str}', expected '#{exp}', got '#{is_palindrome}'"
  raise if is_palindrome != exp
end
