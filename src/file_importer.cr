require "./exceptions"
require "./utils"

require "path"
require "file_utils"

module Dotfiles::FileImporter
  def self.import(path : String)
    import(Path[path])
  end

  def self.import(path : Path)
    dotfile_path = self.dotfile_path(path)
    Dir.mkdir_p(dotfile_path.dirname)

    FileUtils.mv(path, dotfile_path)
    FileUtils.ln_s(dotfile_path, path)
  rescue error : Exception
    raise Exceptions::ImportFailed.new("Failed to import file: #{path}", error)
  end

  def self.dotfile_path(path : Path)
    stripped_path = self.strip_home_from_path(path)

    if stripped_path == path
      raise Exceptions::ImportFailed.new("#{path} is outside of #{Path.home}")
    end

    Utils.repository_path.join(stripped_path)
  end

  def self.strip_home_from_path(path : Path)
    expanded_path = path.expand.to_s
    Path[expanded_path.gsub(/^#{Path.home}/, "")]
  end
end
