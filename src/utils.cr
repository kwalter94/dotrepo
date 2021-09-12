require "dir"
require "file"

module Dotrepo::Utils
  extend self

  ##
  # Recursively lists a directory and all its subdirectories)
  def dir_deep_ls(path, follow_symlinks = false)
    Dir.children(path).each_with_object([] of Path) do |file, contents|
      file_path = path.join(file)
      file_info = File.info?(file_path, follow_symlinks: follow_symlinks)
      next unless file_info

      if file_info.directory?
        dir_deep_ls(file_path).each { |child| contents << child }
      else
        contents << file_path
      end
    end
  end
end
