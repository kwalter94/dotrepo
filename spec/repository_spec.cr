require "../src/repository"
require "./spec_helper"

require "file"
require "path"

describe Dotrepo::Repository do
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
end
