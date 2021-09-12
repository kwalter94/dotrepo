require "../src/repository"
require "./spec_helper"

require "dir"
require "file"
require "file_utils"
require "path"

describe Dotrepo::Repository do
  before_each { Dir.mkdir(Dotrepo::Repository.path) }

  describe :path do
    before_each { ENV.delete("DOTFILES_REPOSITORY") }

    it "uses environment variable 'DOTFILES_REPOSITORY' when available" do
      path = File.tempname
      ENV["DOTFILES_REPOSITORY"] = path

      Dotrepo::Repository.path.should eq(Path[path])
    end

    it "uses .dotfiles directory in user's home when DOTFILES_REPOSITORY is not set" do
      Dotrepo::Repository.path.should eq(Path.home.join(".dotfiles"))
    end
  end

  describe :list do
    it "returns all files saved to repo" do
      repo_files = (1..10).map do |i|
        dir = Dotrepo::Repository.path.join(i.to_s)
        Dir.mkdir(dir)
        Path["/"].join(Path[File.tempfile(dir: dir.to_s).path].relative_to(Dotrepo::Repository.path))
      end

      listed_files = Dotrepo::Repository.list.map(&.path)
      listed_files.sort.should eq(repo_files.sort)
    end

    it "identifies exported files in repo" do
      tempfile = File.tempfile(dir: Dotrepo::Repository.path.to_s)
      FileUtils.ln_s(tempfile.path, Path.home)

      listed_files = Dotrepo::Repository.list
      listed_files.size.should eq(1)
      listed_files.first.full_path.should eq(Path[tempfile.path])
      listed_files.first.exported?.should be_true
    end

    it "identifies unexported files in repo" do
      tempfile = File.tempfile(dir: Dotrepo::Repository.path.to_s)

      listed_files = Dotrepo::Repository.list
      listed_files.size.should eq(1)
      listed_files.first.full_path.should eq(Path[tempfile.path])
      listed_files.first.exported?.should be_false
    end
  end
end
