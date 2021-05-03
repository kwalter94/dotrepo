require "./spec_helper"
require "../src/file_importer"

require "file"

describe Dotfiles::FileImporter do
  describe :import do
    it "moves file to .dotfiles folder" do
      original_file = File.tempfile { |file| file.print("foo: 1") }
      imported_file_path = repository_path.join(Path[original_file.path].basename)

      File.exists?(imported_file_path).should_not be_true
      Dotfiles::FileImporter.import(original_file.path)

      files_match = File.read(imported_file_path) == "foo: 1"
      files_match.should be_true
    end

    it "replaces file with a symlink to new file in .dotfiles folder" do
      original_file = File.tempfile { |file| file.print("foo: 1") }
      imported_file_path = repository_path.join(Path[original_file.path].basename)

      Dotfiles::FileImporter.import(original_file.path)

      File.symlink?(original_file.path).should be_true
      File.readlink(original_file.path).should eq(imported_file_path.to_s)
    end
  end
end
