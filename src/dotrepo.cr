require "./commands"

require "option_parser"

# TODO: Write documentation for `Dotrepo`
module Dotrepo
  VERSION = "1.0.0"

  command : Commands::Command | Nil = nil
  args = Commands::CommandArgs.new
  flags = Commands::CommandFlags.new

  option_parser = OptionParser.parse do |parser|
    parser.banner = "USAGE: dotrepo command [OPTION] [FILE]..."

    parser.on("import", "Import file into repository") do
      parser.banner = "USAGE: dotrepo import [OPTION] FILE [FILE...]"
      parser.unknown_args { |paths| args.replace(paths) }

      command = ->Commands.import(OptionParser, Commands::CommandFlags, Commands::CommandArgs)
    end

    parser.on("export", "Export file from repository") do
      parser.banner = "USAGE: dotrepo export [OPTION] FILE [FILE...]"
      parser.on("-a", "--all", "Export all files in repository") { flags["all"] = "" }
      parser.on("--verbose", "Print all exported files") { flags["verbose"] = "" }
      parser.unknown_args { |paths| args.replace(paths) }

      command = ->Commands.export(OptionParser, Commands::CommandFlags, Commands::CommandArgs)
    end

    parser.on("ls", "Lists all files in repository") do
      parser.banner = "USAGE: dotrepo ls"
      command = ->Commands.list(OptionParser, Commands::CommandFlags, Commands::CommandArgs)
    end

    parser.on("path", "Prints repository path") do
      parser.banner = "USAGE: dotrepo path"
      command = ->Commands.path(OptionParser, Commands::CommandFlags, Commands::CommandArgs)
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

  option_parser.parse

  unless command
    STDERR.puts("ERROR: You need to specify a command")
    STDERR.puts(option_parser)
    exit(1)
  end

  STDOUT.puts(command.try(&.call(option_parser, flags, args)))
end
