require 'fileutils'
require 'pathname'

require_relative '../sort/quick'

# TODO: ...
#   1. Deletion
#   2. In-order?
#   3. Pre-order?
class BinarySearchTree
  def self.from_sorted_array_to_bst(arr = self, tree = nil)
    return if arr.length.zero?

    low = 0
    max = arr.length
    mid = (low + max) >> 1

    if tree.nil?
      tree = Node.new(arr[mid])
    else
      tree << arr[mid]
    end

    from_sorted_array_to_bst(arr[0...mid], tree)
    from_sorted_array_to_bst(arr[(mid + 1)..-1], tree)

    tree
  end

  class EmptyNode
    def to_a
      []
    end

    def include?(*)
      false
    end

    def push(*)
      false
    end
    alias << :push

    def inspect
      '{}'
    end

    def value; end

    def left; end

    def right; end
  end

  class Node
    attr_reader :value, :left, :right

    def initialize(vin)
      @value = vin
      @left = EmptyNode.new
      @right = EmptyNode.new
    end

    def push(vin)
      case value <=> vin
      when 1 then push_left(vin)
      when -1 then push_right(vin)
      when 0 then false
      end
    end
    alias << :push

    def include?(vin)
      case value <=> vin
      when 1 then left.include?(vin)
      when -1 then right.include?(vin)
      when 0 then true
      end
    end

    def inspect
      "{#{value}:#{left.inspect}|#{right.inspect}}"
    end

    def to_a
      left.to_a + [value] + right.to_a
    end

    private

    def left_set(node)
      @left = node
    end

    def right_set(node)
      @right = node
    end

    def push_left(vin)
      left.push(vin) or left_set(Node.new(vin))
    end

    def push_right(vin)
      right.push(vin) or right_set(Node.new(vin))
    end
  end
end
