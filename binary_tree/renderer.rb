require 'graphviz'

class BinarySearchTree
  class Renderer
    def initialize(root_node, value_method: :value)
      @gviz = ARGV[0] ? GraphViz.new('G', path: ARGV[0]) : GraphViz.new('G')
      @value_method = value_method
      build root_node
    end

    def render_to_dot(file = nil)
      render_to_file :dot, file: file
    end

    def render_to_png(file = nil)
      render_to_file :png, file: file
    end

    private

    attr_reader :gviz, :file, :value_method

    def build(root_node)
      gviz_node = gviz.add_nodes(value_get(root_node))
      left = root_node.left

      if left && left.value
        gviz_node_left = gviz.add_nodes(value_get(left))
        gviz.add_edges(gviz_node, gviz_node_left)
        build left
      end

      right = root_node.right
      return if !right || !right.value

      gviz_node_right = gviz.add_nodes(value_get(right))
      gviz.add_edges(gviz_node, gviz_node_right)
      build right
    end

    def value_get(node)
      node.public_send(value_method).to_s
    end

    def render_to_file(output_format, file: nil)
      output_file = file || [
        File.basename($PROGRAM_NAME).sub(/\..*$/, ''), output_format.to_s
      ].join('.')

      gviz.output(output_format => output_file)

      return output_file
    end
  end
end
