require 'fileutils'
require 'pathname'

require_relative './sort/quick'
require_relative './binary_tree/binary_search_tree'
require_relative './binary_tree/renderer'

inputs = Array.new(10) { rand 99 }
# inputs = Array.new(10) { |ix| ix }
sorted = Sort.quick_sort(inputs)

tree = BinarySearchTree.from_sorted_array_to_bst sorted

build_dir = Pathname.new File.join __dir__, 'build'
FileUtils.mkdir_p build_dir if !File.directory?(build_dir)

output_file_bname = 'viz'.freeze
file = build_dir.join("#{output_file_bname}.gv").to_s
BinarySearchTree::Renderer.new(tree).render_to_dot(file)

utils_dir = Pathname.new File.join __dir__, 'binary_tree', 'utils'
final_output_format = 'png'.freeze
pid = spawn(
  {
    'viz_dot_file' => file,
    'gvpr_tree_util' => utils_dir.join('gvpr-tree.gv').to_s,
    'final_output_format' => final_output_format,
    'output_file' => build_dir.join("#{output_file_bname}.#{final_output_format}").to_s
  },
  File.join(utils_dir, 'render.sh')
)
Process.detach(pid)
