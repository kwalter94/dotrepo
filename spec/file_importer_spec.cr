require "./spec_helper"
require "../src/file_importer"

require "file"

describe Dotfiles::FileImporter do
  describe :import do
    it "moves file to .dotfiles folder" do
      filename = create_testfile(&.print("foo: 1"))
      imported_file_path = repository_path.join(filename)

      Dotfiles::FileImporter.import(filename)

      files_match = File.read(imported_file_path) == "foo: 1"
      files_match.should be_true
    end

    it "replaces file with a symlink to new file in .dotfiles folder" do
      filename = create_testfile(&.print("foo: 1"))
      imported_file_path = repository_path.join(filename)

      Dotfiles::FileImporter.import(filename)

      File.symlink?(filename).should be_true
      File.readlink(filename).should eq(imported_file_path.to_s)
    end

    it "maintains relative directory structure in repository folder" do
      filename = create_testfile(relative_dir: ".config/dotfiles", &.print("Hello"))
      # filename comes as a relative path that includes relative_dir above
      imported_dir_path = repository_path.join(".config/dotfiles")

      # Ensure that the directory structure should not already exist
      if Dir.exists?(imported_dir_path)
        imported_dir = Dir.new(imported_dir_path)
        imported_dir.children.each { |child| File.delete(imported_dir_path.join(child)) }
        Dir.delete(imported_dir_path)
      end

      Dotfiles::FileImporter.import(filename)
      Dir.exists?(imported_dir_path).should be_true
    end

    it "does not import files outside of home directory" do
      tempfile = File.tempfile do |file|
        file.puts("Test config...")
      end

      expect_raises(Dotfiles::Exceptions::ImportFailed) do
        Dotfiles::FileImporter.import(tempfile.path)
      end

      tempfile.delete
    end
  end
end
