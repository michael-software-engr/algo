require 'graphviz'

class Heap
  class Renderer
    def initialize(heap_elements)
      @gviz = ARGV[0] ? GraphViz.new('G', path: ARGV[0]) : GraphViz.new('G')
      @value_method = value_method
      build heap_elements
    end

    def render_to_dot(file = nil)
      render_to_file :dot, file
    end

    def render_to_png(file = nil)
      render_to_file :png, file
    end

    private

    attr_reader :gviz, :file, :value_method

    def build(heap_elements)
      heap_elements.each.with_index do |element, idx|
        gviz_node = gviz.add_nodes(get_value_for_gviz_consumption(element))

        last_ix = heap_elements.length - 1

        # Important: the "comment" attribute (values "left" and "right") is used in
        #   the gvpr (gvpr-tree.gv) tool.
        left_ix = left_ix_get idx
        break if left_ix > last_ix

        gviz_node_left = gviz.add_nodes(get_value_for_gviz_consumption(heap_elements[left_ix]))
        gviz.add_edges(gviz_node, gviz_node_left, comment: 'left')

        right_ix = right_ix_get idx
        break if right_ix > last_ix

        gviz_node_right = gviz.add_nodes(get_value_for_gviz_consumption(heap_elements[right_ix]))
        gviz.add_edges(gviz_node, gviz_node_right, comment: 'right')
      end
    end

    def left_ix_get(idx)
      2 * idx + 1
    end

    def right_ix_get(idx)
      2 * idx + 2
    end

    def get_value_for_gviz_consumption(element)
      element.to_s
    end

    def render_to_file(output_format, file = nil)
      output_file = file || [
        File.basename($PROGRAM_NAME).sub(/\..*$/, ''), output_format.to_s
      ].join('.')

      gviz.output(output_format => output_file)

      return output_file
    end
  end
end
