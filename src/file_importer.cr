require "./exceptions"
require "./repository"

require "file_utils"
require "io"
require "path"

##
# Moves files from user's home directory into the dotfiles repository, leaving
# symbolic links to the files.
module Dotrepo::FileImporter
  extend self

  def import(path : String)
    path = path.gsub(/\/+$/, "")
    import(Path[path])
  end

  def import(path : Path)
    dotfile_path = self.dotfile_path(path)
    if File.info?(dotfile_path, follow_symlinks: false)
      # File.exists? and File.file? follow symlinks and can cause program
      # to crash when passed self referencing symlinks.
      raise Exceptions::ImportFailed.new("File already exists in repository: #{dotfile_path}")
    end

    begin
      Dir.mkdir_p(dotfile_path.dirname)
      FileUtils.mv(path, dotfile_path)
      FileUtils.ln_s(dotfile_path, path)
    rescue error : IO::Error
      raise Exceptions::ImportFailed.new(error)
    end
  end

  def dotfile_path(path : Path)
    stripped_path = self.strip_home_from_path(path)

    if stripped_path == path
      raise Exceptions::ImportFailed.new("#{path} is outside of #{Path.home}")
    end

    Repository.path.join(stripped_path)
  end

  def strip_home_from_path(path : Path)
    expanded_path = path.expand.to_s
    Path[expanded_path.gsub(/^#{Path.home}/, "")]
  end
end
