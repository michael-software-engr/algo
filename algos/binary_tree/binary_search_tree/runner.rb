require_relative './binary_search_tree'

elements = Array.new(ARGV&.first&.to_i || 10) { rand 99 }
elements_sorted_uniq = elements.sort.uniq

bst = BinarySearchTree.from_array_to_bst elements

[
  [:in_order, elements_sorted_uniq],
  [:out_order, elements_sorted_uniq.reverse]
].each do |(key, exp)|
  got = bst.public_send key

  next if got == exp

  puts "Test '#{key}' failed..."
  puts "Elements: #{elements}"
  puts "Exp     : #{exp}"
  puts "Got     : #{got}"
  raise '...'
end

[
  # [elements.last, true],
  [elements_sorted_uniq.first, true],
  [1234, false]
].each do |(search_for_this, exp_is_found)|
  got = bst.include? search_for_this

  got_dfs = bst.depth_first_search search_for_this

  # puts "Elements: #{elements}"
  # puts "Search  : #{search_for_this}"
  # puts "Exp     : #{exp_is_found}"
  # puts "Got     : #{got}"
  # puts "Got DFS : #{got_dfs}"

  next if got == exp_is_found && got_dfs == exp_is_found

  puts "Test 'include?' failed..."
  puts "Elements: #{elements}"
  puts "Search  : #{search_for_this}"
  puts "Exp     : #{exp_is_found}"
  puts "Got     : #{got}"
  puts "Got DFS : #{got_dfs}"
  raise '...'
end

puts "Elements     : #{elements}"
[
  *[[:in, 5], [:pre, 4], [:out, 4]].map do |(key, space_count)|
    [[key.to_s, 'order'].join('_'), space_count]
  end,
  # [:breadth_first]
].each do |(order, space_count)|
  space = ' ' * (space_count || 0)
  puts "#{order}#{space}: #{bst.public_send(order)}"
end

puts "BF traversal : #{bst.breadth_first_traversal}"
puts "DF traversal : #{bst.depth_first_traversal}"

require_relative './renderer'

BinarySearchTree::Renderer.new(bst.root_node).render

delete_this = elements_sorted_uniq[elements_sorted_uniq.size / 2]
bst = bst.delete delete_this

puts "After delete : #{delete_this}"
puts "in_order     : #{bst.in_order}"
BinarySearchTree::Renderer.new(bst.root_node).render(bname: 'deleted-node')
