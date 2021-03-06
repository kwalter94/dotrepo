require "spec"
require "../src/repository"

require "dir"
require "file"
require "uuid"

ENV.delete("DOTFILES_REPOSITORY")

TEST_RUN_ID = UUID.random.hexstring

struct Path
  # Used by Dotrepo::Repository.path
  def self.home
    Path[Dir.tempdir].join("dotfiles-#{TEST_RUN_ID}")
  end
end

class Dir
  def self.delete_tree(path : Path)
    if File.info?(path, follow_symlinks: false).try(&.directory?)
      Dir.children(path).each { |child| delete_tree(path.join(child)) }
      Dir.delete(path)
    else
      File.delete(path)
    end
  end

  def self.delete_tree(path)
    self.delete_tree(Path[path])
  end
end

def repository_path
  Dotrepo::Repository.path
end

def create_testfile(relative_dir = nil)
  testfile = File.tempfile(expand_relative_dir(relative_dir), nil) { |file| yield file }
  filename = Path[testfile.path].basename

  return filename unless relative_dir

  Path[relative_dir].join(filename).to_s
end

def expand_relative_dir(relative_dir)
  dir = relative_dir ? Path.home.join(relative_dir) : Path.home
  Dir.mkdir_p(dir) unless Dir.exists?(dir)

  "#{dir}/"
    .gsub(Path.home.dirname.to_s, "")
    .gsub(/^\/+/, "")
end

Spec.before_each do
  # Ensure that relative paths resolve to the correct directory
  Dir.mkdir_p(Path.home)
  Dir.cd(Path.home)
end

Spec.after_each do
  Dir.cd(Dir.tempdir)
  Dir.delete_tree(Path.home)
end
