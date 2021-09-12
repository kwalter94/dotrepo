require "./utils"

require "file"
require "path"

module Dotrepo::Repository
  extend self

  struct Dotfile
    getter path : Path # Relative path (Repository.path stripped out)
    getter full_path : Path
    getter export_path : Path

    def initialize(@path)
      @full_path = Dotrepo::Repository.path.join(@path)
      @export_path = Path.home.join(@path)
    end

    def exported?
      File.info?(export_path, follow_symlinks: false) != nil
    end
  end

  def list : Array(Dotfile)
    Utils.dir_deep_ls(path).map do |dotfile_path|
      relative_dotfile_path = Path["/"].join(dotfile_path.expand.relative_to(path))
      Dotfile.new(relative_dotfile_path)
    end
  end

  def path
    return Path[ENV["DOTFILES_REPOSITORY"]] if ENV.has_key?("DOTFILES_REPOSITORY")

    Path.home.join(".dotfiles")
  end
end
