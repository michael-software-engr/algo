class Iter
  def initialize(list)
    @list = list
    @index = 0
  end

  def value
    list[index]
  end

  def step
    @index += 1
  end

  def next
    list[index + 1]
  end

  def next?
    index < list.length
  end

  private

  attr_reader :list, :index
end

list = Array.new(10) { rand 99 }
iter = Iter.new list

puts "Inputs: #{list}"
list.each.with_index do |num, ix|
  puts "Current, next, exp: #{num}, #{list[ix + 1]} (ix: #{ix})"
  puts "               got: #{iter.value}, #{iter.next}"
  raise if num != iter.value

  if ix < list.length
    raise if !iter.next?
    raise if list[ix + 1] != iter.next
    iter.step
  end
end

# class Portfolio
#   # include Enumerable

#   def initialize
#     @accounts = []
#   end

#   def each(&block)
#     ix = 0
#     while ix < @accounts.length
#       yield @accounts[ix]
#       ix += 1
#     end
#     # @accounts.each(&block)
#   end

#   def add_account(account)
#     @accounts << account
#   end
# end

# accounts = Array.new(10) { rand 99 }
# portfolio = Portfolio.new
# accounts.each { |acct| portfolio.add_account acct }

# puts "Inputs: #{accounts}"
# portfolio.each do |acct|
#   puts "Acct  : #{acct}"
# end
