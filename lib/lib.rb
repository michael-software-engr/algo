require 'fileutils'
require 'pathname'

module Algo
  module Lib
    class << self
      def root_dir
        Pathname.new File.dirname __dir__
      end

      def lib_dir
        root_dir.join 'lib'
      end

      def gvpr_tree_file
        lib_dir.join('gvpr-tree.gv').to_s
      end

      def setup_build_dir(dir_bname: nil)
        dir_bname ||= File.dirname($PROGRAM_NAME)

        build_dir = root_dir.join 'build', dir_bname

        return build_dir if File.directory?(build_dir)

        FileUtils.mkdir_p build_dir
        return build_dir if File.directory?(build_dir)

        raise "... failed to create dir '#{build_dir}'."
      end

      def renderer_script
        root_dir.join('lib', 'renderer.sh').to_s
      end
    end
  end
end
