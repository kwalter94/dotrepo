require "./spec_helper"
require "../src/file_importer"

require "file"

describe Dotrepo::FileImporter do
  describe :import do
    it "moves file to .dotfiles folder" do
      filename = create_testfile(&.print("foo: 1"))
      imported_file_path = repository_path.join(filename)

      Dotrepo::FileImporter.import(filename)

      files_match = File.read(imported_file_path) == "foo: 1"
      files_match.should be_true
    end

    it "replaces file with a symlink to new file in .dotfiles folder" do
      filename = create_testfile(&.print("foo: 1"))
      imported_file_path = repository_path.join(filename)

      Dotrepo::FileImporter.import(filename)

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

      Dotrepo::FileImporter.import(filename)
      Dir.exists?(imported_dir_path).should be_true
    end

    it "does not import files outside of home directory" do
      tempfile = File.tempfile do |file|
        file.puts("Test config...")
      end

      expect_raises(Dotrepo::Exceptions::ImportFailed) do
        Dotrepo::FileImporter.import(tempfile.path)
      end

      tempfile.delete
    end

    it "throws an error when dotfile already exists in repository" do
      tempfile = File.tempfile(dir: Path.home.to_s, &.puts("Hello"))
      Dotrepo::FileImporter.import(tempfile.path)

      expect_raises(Dotrepo::Exceptions::ImportFailed) do
        Dotrepo::FileImporter.import(tempfile.path)
      end
    end

    # Had some wicked bug that would cause imports on directories to
    # fail if import was called with a directory path that had a
    # a trailing /
    it "imports directory trees with trailing slashes in their name" do
      dirname = ".config"
      import_dir = Dotrepo::Repository.path.join(dirname)

      files = (1..10).map do |i|
        {i, create_testfile(relative_dir: dirname, &.print("Hello x#{i}"))}
      end

      Dotrepo::FileImporter.import("#{dirname}/")

      # Trimming out the trailing / because when linux sees it after a symlink,
      # the path is treated as a directory not a symlink
      File.readlink(dirname).should eq(import_dir.to_s)
      File.directory?(import_dir).should be_true

      files.each do |file|
        file_no, filename = file
        filename = File.basename(filename)
        File.read(import_dir.join(filename)).should eq("Hello x#{file_no}")
      end
    end
  end
end
