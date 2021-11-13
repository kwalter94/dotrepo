require "./spec_helper"

require "../src/file_exporter"

require "dir"
require "file"
require "path"

describe Dotrepo::FileExporter do
  before_each do
    Dir.mkdir_p(repository_path)
  end

  after_each do
    Dir.delete_tree(repository_path)
  end

  describe :export_file do
    it "creates a symbolic link to a file in .dotfiles folder" do
      dotfile_path = File.tempfile(dir: repository_path.to_s, &.print("Hello")).path
      export_filename = Path[dotfile_path].basename
      exported_path = Path.home.join(export_filename)

      Dotrepo::FileExporter.export(export_filename)
      File.symlink?(exported_path).should be_true
      File.readlink(exported_path).should eq(repository_path.join(export_filename).to_s)
    end

    it "maintains relative directory structure for exported paths" do
      dotfile_dir_path = repository_path.join("some", "relative", "path")
      Dir.mkdir_p(dotfile_dir_path)

      dotfile_path = File.tempfile(dir: dotfile_dir_path.to_s, &.print("Hello")).path
      export_filename = Path[dotfile_path].basename
      exported_path = Path.home.join("some", "relative", "path", export_filename)

      Dotrepo::FileExporter.export("some/relative/path/#{export_filename}")
      Dir.exists?(exported_path.dirname).should eq(true)
      Path[File.readlink(exported_path)].should eq(Path[dotfile_path])
    end

    it "raises Exceptions::ExportFailed when specified file does not exist" do
      expect_raises(Dotrepo::Exceptions::ExportFailed, /Dotfile .* does not exist/i) do
        Dotrepo::FileExporter.export("/file-that-does-not-exist")
      end
    end

    it "raises Exceptions::ExportFailed when export target already exists" do
      expect_raises(Dotrepo::Exceptions::ExportFailed, /File exists/i) do
        export_file = File.tempfile(dir: repository_path.to_s, &.print("Hello")).path
        FileUtils.cp(export_file.to_s, Path.home.to_s)

        Dotrepo::FileExporter.export(Path["/"].join(Path[export_file].basename))
      end
    end
  end
end
