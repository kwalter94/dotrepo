require "dir"
require "file"
require "path"

module Dotfiles::Utils
  def self.repository_path
    Path["#{Path.home}/.dotfiles"]
  end
end
