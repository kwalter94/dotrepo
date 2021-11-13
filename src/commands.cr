require "./exceptions"
require "./file_exporter"
require "./file_importer"
require "./repository"

require "option_parser"

module Dotrepo::Commands
  extend self

  alias CommandArgs = Array(String)
  alias CommandFlags = Hash(String, String)
  alias Command = OptionParser, CommandFlags, CommandArgs -> Nil

  def import(parser : OptionParser, _flags : CommandFlags, args : CommandArgs)
    if args.empty?
      STDERR.puts("ERROR: You need to specify at least one file to import")
      STDERR.puts(parser)
      exit(1)
    end

    args.each do |path|
      FileImporter.import(path)
    rescue e : Exceptions::Exception
      STDERR.puts("ERROR: Failed to import file #{path}: #{e}")
      exit(1)
    end
  end

  def export(parser : OptionParser, flags : CommandFlags, args : CommandArgs)
    files = Repository.list.map(&.path) if flags.has_key?("all")

    if files.nil? && args.empty?
      STDERR.puts("ERROR: You need to specify at least one file to import")
      STDERR.puts(parser)
      exit(1)
    end

    (files || args).each do |path|
      destination_path = FileExporter.export(path)
      puts "#{path} => #{destination_path}" if flags.has_key?("verbose")
    rescue e : Exceptions::Exception
      STDERR.puts("Warning: Failed to export file #{path}: #{e}")
    end
  end

  def list(_parser : OptionParser, _flags : CommandFlags, _args : CommandArgs)
    Repository.list.each do |file|
      if file.exported?
        puts "#{file.path}"
      else
        puts "\033[0;31m#{file.path}\033[0m"
      end
    end
  end

  def path(_parse : OptionParser, _flags : CommandFlags, _args : CommandArgs)
    puts Repository.path
  end
end
