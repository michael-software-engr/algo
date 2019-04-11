require 'fileutils'
require 'pathname'
require 'active_support/inflector'

require_relative '../../sort/quick'
require_relative '../../lib/lib'

require_relative './binary_search_tree'
require_relative './renderer'

class BinarySearchTree
  class Runner
    def run
      inputs = Array.new(10) { rand 99 }
      # inputs = Array.new(10) { |ix| ix }
      sorted = Sort.quick_sort(inputs)

      tree = BinarySearchTree.from_sorted_array_to_bst sorted

      bname = self.class.name.deconstantize.underscore
      build_dir = Algo::Lib.setup_build_dir dir_bname: bname

      output_file_bname = bname
      file = build_dir.join("#{output_file_bname}.gv").to_s
      BinarySearchTree::Renderer.new(tree).render_to_dot(file)

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
  end
end

BinarySearchTree::Runner.new.run
