require "dir"
require "file"
require "path"

module Dotfiles::Utils
  def self.repository_path
    path = Path["#{Path.home}/.dotfiles"]

    Dir.mkdir(path) unless File.exists?(path)

    path
  end
end
