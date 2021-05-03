require "./exceptions"
require "./utils"

require "path"
require "file_utils"

module Dotfiles::FileImporter
  def self.import(path : String)
    import(Path[path])
  end

  def self.import(path : String)
    dotfile_path = self.dotfile_path(filename(path))
    FileUtils.mv(path, dotfile_path)
    FileUtils.ln_s(dotfile_path, path)
  rescue error : Exception
    raise Exceptions::ImportFailed.new("Failed to import file: #{path}", error)
  end

  def self.dotfile_path(filename : String)
    Utils.repository_path.join(filename).to_s
  end

  def self.filename(path : String)
    Path[path].basename
  end
end
