require_relative '../../algos/binary_tree/binary_search_tree/binary_search_tree'

elements = Array.new(ARGV&.first&.to_i || 10) { rand 99 }
elements_sorted_uniq = elements.sort.uniq

bst = BinarySearchTree.from_array_to_bst elements

puts ['Input', ' ' * 7, ':', ' ', elements.inspect].join
puts
[
  [:in_order, elements_sorted_uniq],
  [:out_order, elements_sorted_uniq.reverse]
].each do |(key, exp)|
  got = bst.public_send key

  next if got == exp

  puts "Test '#{key}' failed..."
  puts "Expected  : #{exp}"
  puts "Got       : #{got}"
  raise '...'
end

[
  [-1, false],
  [elements.first, true],
  [elements[rand(elements.count - 1)], true],
  [elements.last, true],
  [123, false]
].each do |(search_for_this, exp_is_found)|
  got = bst.include? search_for_this

  got_dfs = bst.depth_first_search search_for_this
  got_bfs = bst.breadth_first_search search_for_this

  are_expectations_met = got == exp_is_found && got_dfs == exp_is_found && got_bfs == exp_is_found

  puts 'ERROR: expectations not met...' if !are_expectations_met

  puts "Search this : #{search_for_this}"
  puts "Expected    : #{exp_is_found}"
  puts "Got         : #{got}, #{got_dfs}, #{got_bfs} (binary search, DFS, BFS)"

  raise '...' if !are_expectations_met

  puts
end

[
  *[[:in, 4], [:pre, 3], [:out, 3]].map do |(key, space_count)|
    [[key.to_s, 'order'].join('_'), space_count]
  end
].each do |(order, space_count)|
  space = ' ' * (space_count || 0)
  puts "#{order}#{space}: #{bst.public_send(order)}"
end

puts "BF traversal: #{bst.breadth_first_traversal}"
puts "DF traversal: #{bst.depth_first_traversal}"
puts

value_a = elements_sorted_uniq[1]
value_b = elements_sorted_uniq[3]
lca     = bst.lca(value_a, value_b)
puts "LCA         : #{lca.value} of #{value_a} and #{value_b}"
puts

require_relative '../../algos/binary_tree/binary_search_tree/renderer'

jnr = '-'.freeze

# Assuming this file is in doc/examples/
bname = File.basename __FILE__.split(File::SEPARATOR).reverse[0..2].reverse.join(jnr), '.*'

BinarySearchTree::Renderer.new(bst.root_node).render(bname: bname)

delete_this = elements_sorted_uniq[rand(elements_sorted_uniq.count - 1)]
bst = bst.delete delete_this

puts "Delete      : #{delete_this}"
puts "in_order    : #{bst.in_order} (after delete)"
BinarySearchTree::Renderer.new(bst.root_node).render(bname: [bname, 'deleted-node'].join(jnr))
