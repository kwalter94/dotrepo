require "spec"
require "../src/dotfiles"

require "dir"

struct Path
  def self.home
    Path[Dir.tempdir]
  end
end
