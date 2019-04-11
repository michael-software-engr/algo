require 'fileutils'
require 'pathname'

require_relative './heap'
require_relative './renderer'
require_relative '../lib/lib'

class Heap
  class Runner
    def run(is_min_heap = nil)
      inputs = Array.new(10) { rand 99 }

      is_min_heap &&= !is_min_heap.empty?

      heap = Heap.new inputs, is_max_heap: !is_min_heap

      build_dir = Algo::Lib.setup_build_dir

      output_file_bname = File.basename __dir__
      file = build_dir.join("#{output_file_bname}.gv").to_s
      Heap::Renderer.new(heap.data).render_to_dot(file)

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

      hver = HeapVerify.new(*inputs, min_heap: is_min_heap)
      verif = heap.data == hver.data
      return if verif

      puts "Inputs: #{inputs}"
      puts "Heap  : #{heap.data}"

      puts "Verif : #{hver.data}"
      puts "Verif : #{verif}"
      raise
    end
  end
end

Heap::Runner.new.run ARGV.first
