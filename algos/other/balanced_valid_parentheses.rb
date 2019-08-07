class BalancedValidParentheses
  def initialize(input = nil)
    @input = input
    @pstack = []
  end

  def balanced?(str = nil)
    is_balanced_got = nil

    reinit(str) if str

    input.chars.each do |chr|
      if opening_parens?(chr)
        @pstack.push chr
      elsif closing_parens?(chr)
        if not_balanced?(chr)
          is_balanced_got = false
          break
        end

        @pstack.pop
      end
    end

    return is_balanced_got.nil? ? pstack.empty? : is_balanced_got
  end

  private

  attr_reader :input, :pstack

  def reinit(str)
    @pstack = []
    @input = str
  end

  def opening_parens?(chr)
    ['(', '{', '['].include? chr
  end

  def closing_parens?(chr)
    [')', '}', ']'].include? chr
  end

  def pair_of_last_stack_element?(chr)
    last_stack_element = pstack.last

    pair_table = {
      ')' => '(',
      '}' => '{',
      ']' => '['
    }

    return pair_table[chr] == last_stack_element
  end

  def not_balanced?(chr)
    pstack.empty? || !pair_of_last_stack_element?(chr)
  end
end

bvp = BalancedValidParentheses.new
[
  ['(abcd)', true],
  ['[abcd(efgh])', false],
  ['{ [ ( ) ] }', true],
  [')(', false]
].each do |(test_string, is_balanced_exp)|
  tmsg = is_balanced_exp ? 'balanced' : 'not balanced'

  raise "'#{test_string}' should be #{tmsg}." if bvp.balanced?(test_string) != is_balanced_exp
end

# def opening_parens?(chr)
#   ['(', '{', '['].include? chr
# end

# def closing_parens?(chr)
#   [')', '}', ']'].include? chr
# end

# def pair_of_last_stack_element?(chr, pstack)
#   last_stack_element = pstack.last

#   pair_table = {
#     ')' => '(',
#     '}' => '{',
#     ']' => '['
#   }

#   return pair_table[chr] == last_stack_element
# end

# [
#   ['(abcd)', true],
#   ['[abcd(efgh])', false],
#   ['{ [ ( ) ] }', true],
#   [')(', false]
# ].each do |(test_string, is_balanced_exp)|
#   pstack = []
#   is_balanced_got = nil

#   test_string.chars.each do |chr|
#     if opening_parens?(chr)
#       pstack.push chr
#     elsif closing_parens?(chr)
#       if pstack.empty? || !pair_of_last_stack_element?(chr, pstack)
#         is_balanced_got = false
#         break
#       end

#       pstack.pop
#     end
#   end

#   is_balanced_got = is_balanced_got.nil? ? pstack.empty? : is_balanced_got

#   tmsg = is_balanced_exp ? 'balanced' : 'not balanced'

#   raise "'#{test_string}' should be #{tmsg}." if is_balanced_got != is_balanced_exp
# end
