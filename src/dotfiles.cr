require "option_parser"

require "./file_importer"

# TODO: Write documentation for `Dotfiles`
module Dotfiles
  VERSION = "0.1.0"

  alias CommandArgs = Array(String)
  alias CommandFlags = Hash(String, String | Bool)
  alias Command = CommandFlags, CommandArgs -> Nil

  command : Command | Nil = nil
  flags : CommandFlags = CommandFlags.new
  args : CommandArgs = [] of String

  parser = OptionParser.parse do |parser|
    parser.banner = "USAGE: dotfiles command [OPTION] [FILE]..."

    parser.on("import", "Import file") do
      parser.banner = "USAGE: dotfiles import [OPTION] [FILE]..."
      parser.unknown_args { |paths| args = paths }

      command = ->(_flags : CommandFlags, args : CommandArgs) do
        if args.empty?
          STDERR.puts("ERROR: You need to specify at least one file to import")
          STDERR.puts(parser)
          exit(1)
        end

        args.each do |path|
          FileImporter.import(path)
        end

        exit(0)
      end
    end

    parser.on("-h", "--help", "Show this help") do
      puts(parser)
      exit(0)
    end

    parser.invalid_option do |option|
      STDERR.puts("ERROR: Invalid option #{option}")
      STDERR.puts(parser)
      exit(1)
    end
  end

  unless command
    STDERR.puts("ERROR: You need to specify a command")
    STDERR.puts(parser)
    exit(1)
  end

  command.try do |command|
    command.call(flags, args)
  end
end
