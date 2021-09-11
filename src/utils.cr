require "dir"
require "file"
require "path"

module Dotfiles::Utils
  def self.repository_path
    Path.home.join(".dotfiles")
  end
end
