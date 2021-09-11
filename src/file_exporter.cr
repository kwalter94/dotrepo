require "./exceptions"
require "./utils"

require "file_utils"
require "path"

module Dotfiles::FileExporter
  ##
  # Imports dotfile from the dotfiles repository.
  #
  # For example `Dotfiles::FileExporter.export_file(".config/fish/config.fish"])`
  # creates a symlink at ~/.config/fish/config.fish to the corresponding file in
  # the dotfiles repository.
  def self.export_file(relative_dotfile_path : String)
    export_file(Path[relative_dotfile_path])
  end

  ##
  # Imports dotfile from the dotfiles repository.
  #
  # For example `Dotfiles::FileExporter.export_file(Path[".config", "fish", "config.fish"])`
  # creates a symlink at ~/.config/fish/config.fish to the corresponding file in
  # the dotfiles repository.
  def self.export_file(relative_dotfile_path : Path)
    dotfile_path = expand_dotfile_path(relative_dotfile_path)
    unless File.exists?(dotfile_path)
      raise Exceptions::ExportFailed.new("Dotfile #{relative_dotfile_path} does not exist")
    end

    export_path = dotfile_export_path(relative_dotfile_path)
    Dir.mkdir_p(export_path.dirname)
    FileUtils.ln_s(dotfile_path, export_path)

    export_path
  end

  def self.expand_dotfile_path(relative_dotfile_path : Path)
    Utils.repository_path.join(relative_dotfile_path)
  end

  def self.dotfile_export_path(relative_dotfile_path : Path)
    Path.home.join(relative_dotfile_path)
  end
end
