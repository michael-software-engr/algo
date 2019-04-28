require_relative '../../sort/quick'

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
      def traversal(node)
        queue = [node]
        output = []

        while !queue.empty?
          current = queue.shift

          queue.push(current.left) if current.left

          queue.push(current.right) if current.right

          output.push(current.value)
        end

        return output
      end

      def search(search_value, node) # rubocop:disable Metrics/CyclomaticComplexity, Metrics/PerceivedComplexity, Style/LineLength
        queue = [node]
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

  class LeastCommonAncestor
    class << self
      # Assumption is both values are found in the tree.
      # Validations should be done prior to invoking this method.
      def search(node, value_a, value_b)
        lca = new value_a, value_b
        lca.perform node
      end
    end

    def initialize(value_a, value_b)
      @value_a = value_a
      @value_b = value_b
      @lca_has_been_found = false
    end

    # Find p and q (value_a and value_b) using DFS.
    # It will recurse until p, q or nil is found.
    # ... will return nil because other branch does not contain p or q.
    def perform(node) # rubocop:disable Metrics/CyclomaticComplexity, Metrics/PerceivedComplexity, Style/LineLength
      return if node.nil? || lca_has_been_found

      # If the root is one of a or b, then it is the LCA.
      return node if node.value == value_a || node.value == value_b

      left = perform node.left
      right = perform node.right

      if !left.nil? && !right.nil?
        lca_has_been_found_set
        return node
      end

      return left.nil? ? right : left
    end

    private

    attr_reader :value_a, :value_b, :lca_has_been_found

    def lca_has_been_found_set
      @lca_has_been_found = true
    end
  end

  def self.from_array_to_bst(arr, tree = nil)
    return if arr.length.zero?

    arr = tree ? arr : Sort.quick_sort(arr)

    lo_ix = 0
    hi_ix = arr.length - 1
    md_ix = (lo_ix + hi_ix) >> 1

    md_val = arr[md_ix]
    if tree.nil?
      tree = new md_val
    else
      tree << md_val
    end

    from_array_to_bst(arr[0..(md_ix - 1)], tree) if md_ix.positive?
    from_array_to_bst(arr[(md_ix + 1)..-1], tree)

    return tree
  end

  module Base
    class << self
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
  end

  attr_reader :root_node
  def initialize(vin)
    @root_node = Node.new vin
  end

  def push(vin)
    Base.do_push vin, root_node
  end
  alias << push

  def search(vin)
    Base.do_search(vin, root_node) { |node| node }
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
    Base.do_search(vin, root_node) { true }
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
    [value_a, value_b].each do |lcav|
      raise "Can't find LCA because value '#{lcav}' doesn't exist in tree." if !include? lcav
    end
    LeastCommonAncestor.search root_node, value_a, value_b
  end
end
