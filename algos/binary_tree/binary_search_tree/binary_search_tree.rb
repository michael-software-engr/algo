require_relative '../../sort/quick'

# TODO: ...
#   / 1. Deletion
#   / 2. In-order?
#   / 3. Pre-order?
#   / 4. Depth-first
#   / 5. Breadth-first
#   / 6. Least common ancestor
#   / 7. Tests
#   8. Understand LCA

class BinarySearchTree
  class Node
    attr_reader :value, :left, :right

    def initialize(vin)
      @value = vin
      @left = nil
      @right = nil
    end

    def value_set(vin)
      @value = vin
    end

    def left_set(vin)
      @left = Node.new vin
    end

    def right_set(vin)
      @right = Node.new vin
    end
  end
  private_constant :Node

  module Order
    def self.perform(node, order)
      left = node.left
      right = node.right

      left_list = left ? perform(left, order) : []
      current_list = [node.value]
      right_list = right ? perform(right, order) : []

      order_table = {
        in: left_list + current_list + right_list,
        out: right_list + current_list + left_list,
        pre: current_list + left_list + right_list
      }

      list = order_table[order]

      raise "Order '#{order}' not supported." if !list

      return list
    end
  end
  private_constant :Order

  module DepthFirst
    class << self
      def traversal(root_node)
        stack = [root_node]
        visited = [root_node]

        while !stack.empty?
          current = stack.last
          left = current.left
          right = current.right

          if !left.nil? && !visited.include?(left)
            visited << left
            stack << left
          elsif !right.nil? && !visited.include?(right)
            visited << right
            stack << right
          else
            stack.pop
          end
        end

        return visited.map(&:value)
      end

      def search(search_value, root_node) # rubocop:disable Metrics/CyclomaticComplexity, Metrics/PerceivedComplexity, Style/LineLength
        stack = [root_node]
        visited = [root_node]
        found = nil

        while !stack.empty? && !found
          current = stack.last
          left = current.left
          right = current.right

          if current.value == search_value
            found = current
          elsif !left.nil? && !visited.include?(left)
            if left.value == search_value
              found = left
            else
              visited << left
              stack << left
            end
          elsif !right.nil? && !visited.include?(right)
            if right.value == search_value
              found = right
            else
              visited << right
              stack << right
            end
          else
            stack.pop
          end
        end

        return yield found if block_given?

        return found ? true : false
      end
    end
  end
  private_constant :DepthFirst

  module BreadthFirst
    class << self
      def traversal(root_node)
        node = root_node

        queue = []
        output = []

        queue.push(node)

        while !queue.empty?
          current = queue.shift

          queue.push(current.left) if current.left

          queue.push(current.right) if current.right

          output.push(current.value)
        end

        return output
      end

      def search(search_value, root_node) # rubocop:disable Metrics/CyclomaticComplexity, Metrics/PerceivedComplexity, Style/LineLength
        node = root_node

        queue = []

        queue.push(node)
        found = nil
        while !queue.empty? && !found
          current = queue.shift

          queue.push(current.left) if current.left

          queue.push(current.right) if current.right

          found = current if current.value == search_value
        end

        return yield found if block_given?

        return found ? true : false
      end
    end
  end
  private_constant :BreadthFirst

  module LeastCommonAncestor
    class << self
      def search(node, value_a, value_b) # rubocop:disable Metrics/CyclomaticComplexity, Style/LineLength
        return nil if node.nil?

        # If the root is one of a or b, then it is the LCA.
        return node if node.value == value_a || node.value == value_b

        left = search node.left, value_a, value_b
        right = search node.right, value_a, value_b

        # If both nodes lie in left or right then their LCA is in left or right,
        # Otherwise root is their LCA
        return node if !left.nil? && !right.nil?

        return left.nil? ? right : left
      end
    end
  end

  def self.from_array_to_bst(arr, tree = nil)
    return if arr.length.zero?

    arr = tree ? arr : Sort.quick_sort(arr)

    low = 0
    max = arr.length
    mid = (low + max) >> 1

    if tree.nil?
      tree = new arr[mid]
    else
      tree << arr[mid]
    end

    from_array_to_bst(arr[0...mid], tree)
    from_array_to_bst(arr[(mid + 1)..-1], tree)

    tree
  end

  attr_reader :root_node
  def initialize(vin)
    @root_node = Node.new vin
  end

  def push(vin)
    do_push vin, root_node
  end
  alias << push

  def search(vin)
    do_search(vin, root_node) { |node| node }
  end

  def in_order
    Order.perform root_node, :in
  end
  alias to_a in_order

  def out_order
    Order.perform root_node, :out
  end

  def pre_order
    Order.perform root_node, :pre
  end

  def include?(vin)
    do_search(vin, root_node) { true }
  end

  def depth_first_traversal
    DepthFirst.traversal root_node
  end

  def depth_first_search(search_value)
    DepthFirst.search search_value, root_node
  end

  def breadth_first_search(search_value)
    BreadthFirst.search search_value, root_node
  end

  def breadth_first_traversal
    BreadthFirst.traversal root_node
  end

  def delete(vin)
    node = search(vin)

    node.value_set nil

    elements = in_order.reject(&:nil?)

    return self.class.from_array_to_bst elements
  end

  def lca(value_a, value_b)
    [value_a, value_b].each do |lca_value|
      if !include? lca_value
        raise "Can't find LCA because value '#{lca_value}' doesn't exist in tree."
      end
    end
    LeastCommonAncestor.search root_node, value_a, value_b
  end

  private

  def do_push(vin, node)
    case node.value <=> vin
    when -1
      return do_push(vin, node.right) if node.right

      return node.right_set vin
    when 0
      false
    when 1
      return do_push(vin, node.left) if node.left

      return node.left_set vin
    else
      raise 'Should not end up here.'
    end
  end

  def do_search(vin, node, &block)
    case node.value <=> vin
    when -1
      right = node.right
      return false if !right

      return do_search vin, right, &block
    when 0
      yield node
    when 1
      left = node.left
      return false if !left

      return do_search vin, left, &block
    else
      puts "What? #{node.value <=> vin} #{node.value} #{vin}"
      raise 'Should not end up here.'
    end
  end
end
