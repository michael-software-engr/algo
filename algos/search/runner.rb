require 'benchmark'

require_relative './binary_search'

list = Array.new(10) { rand 99 }
sorted = list.sort

bsearch = Search::BinarySearch.new sorted

to_search = ENV['found'] ? list.last : rand(99)

result = bsearch.run to_search

puts "List     : #{list}"
puts "Sorted   : #{sorted}"
puts "To search: #{to_search}"
puts "Result   : #{result}"

array = Array.new(5000) { rand 50_000 }

bsearch = Search::BinarySearch.new array.sort
array_found = nil
bsearch_found = nil
Benchmark.bm do |benchmark|
  benchmark.report('array#include?') do
    array_found = (1..50_000).select { |v| array.include?(v) }
  end

  benchmark.report('binary search') do
    bsearch_found = (1..50_000).select { |v| bsearch.run(v) }
  end
end

[[:array, array_found], [:binary_search, bsearch_found]].each do |(title, found)|
  puts "#{title} found: #{found.count}"
end

array_found == bsearch_found || raise
