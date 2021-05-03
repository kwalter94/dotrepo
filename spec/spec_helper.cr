require "spec"
require "../src/dotfiles"
require "../src/utils"

require "dir"

struct Path
  def self.home
    Path[Dir.tempdir]
  end
end

def repository_path
  Dotfiles::Utils.repository_path
end
