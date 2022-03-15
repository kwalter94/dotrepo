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
    dotfiles = Utils.dir_deep_ls(path).map do |dotfile_path|
      relative_dotfile_path = Path["/"].join(dotfile_path.expand.relative_to(path))
      next nil if ignore_dotfile?(relative_dotfile_path)

      Dotfile.new(relative_dotfile_path)
    end

    dotfiles.compact
  end

  def path
    return Path[ENV["DOTFILES_REPOSITORY"]] if ENV.has_key?("DOTFILES_REPOSITORY")

    Path.home.join(".dotfiles")
  end

  def ignore_dotfile?(relative_path : Path)
    matching_pattern = ignored_file_patterns.find do |pattern|
      if pattern.starts_with?('/')
        relative_path.parts[1] == pattern[1..]
      else
        relative_path.parts.find { |part| part == pattern }
      end
    end

    matching_pattern != nil
  end

  def ignored_file_patterns
    dotignore_file = path.join("dotrepo-ignore")
    return [] of String unless File.exists?(dotignore_file)

    patterns = File.read_lines(dotignore_file).map do |line|
      line = line.strip
      next nil if line.empty? || line.starts_with?('#')

      line
    end

    patterns << "/dotrepo-ignore"
    patterns.compact
  end
end
