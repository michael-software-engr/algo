require 'graphviz'

require_relative '../../../lib/lib'

class BinarySearchTree
  class Renderer
    def initialize(root_node, value_method: :value)
      @gviz = ARGV[0] ? GraphViz.new('G', path: ARGV[0]) : GraphViz.new('G')
      @value_method = value_method
      build root_node
    end

    def render_to_dot(file = nil)
      render_to_file :dot, file
    end

    def render_to_png(file = nil)
      render_to_file :png, file
    end

    def render(bname: nil, build_dir: nil, output_file_bname: nil)
      bname ||= bname_get
      build_dir ||= Algo::Lib.setup_build_dir dir_bname: bname
      output_file_bname ||= bname

      file = build_dir.join("#{output_file_bname}.gv").to_s

      render_to_dot(file)

      final_output_format = 'png'.freeze

      system(
        {
          'viz_dot_file' => file,
          'gvpr_tree_util' => Algo::Lib.gvpr_tree_file,
          'final_output_format' => final_output_format,
          'output_file' => build_dir.join("#{output_file_bname}.#{final_output_format}").to_s
        },
        Algo::Lib.renderer_script
      ) || raise
    end

    private

    attr_reader :gviz, :file, :value_method

    def build(root_node)
      gviz_node = gviz.add_nodes(get_value_for_gviz_consumption(root_node))
      left = root_node.left

      # Important: the "comment" attribute (values "left" and "right") is used in
      #   the gvpr (gvpr-tree.gv) tool.
      if left && left.value
        gviz_node_left = gviz.add_nodes(get_value_for_gviz_consumption(left))
        gviz.add_edges(gviz_node, gviz_node_left, comment: 'left')
        build left
      end

      right = root_node.right
      return if !right || !right.value

      gviz_node_right = gviz.add_nodes(get_value_for_gviz_consumption(right))
      gviz.add_edges(gviz_node, gviz_node_right, comment: 'right')
      build right
    end

    def get_value_for_gviz_consumption(node)
      node.public_send(value_method).to_s
    end

    def render_to_file(output_format, file = nil)
      output_file = file || [
        File.basename($PROGRAM_NAME).sub(/\..*$/, ''), output_format.to_s
      ].join('.')

      gviz.output(output_format => output_file)

      return output_file
    end

    def bname_get
      File.basename(caller(2..2).first.split(':').first, '.*')
    end
  end
end
