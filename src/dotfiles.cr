require "./commands"

require "option_parser"

# TODO: Write documentation for `Dotfiles`
module Dotfiles
  VERSION = "0.1.0"

  command : Commands::Command | Nil = nil
  args = Commands::CommandArgs.new
  flags = Commands::CommandFlags.new

  option_parser = OptionParser.parse do |parser|
    parser.banner = "USAGE: dotfiles command [OPTION] [FILE]..."

    parser.on("import", "Import file into repository") do
      parser.banner = "USAGE: dotfiles import [OPTION] FILE [FILE...]"
      parser.unknown_args { |paths| args.replace(paths) }

      command = ->Commands.import(OptionParser, Commands::CommandFlags, Commands::CommandArgs)
    end

    parser.on("export", "Export file from repository") do
      parser.banner = "USAGE: dotfiles export [OPTION] FILE [FILE...]"
      parser.unknown_args { |paths| args.replace(paths) }

      command = ->Commands.export(OptionParser, Commands::CommandFlags, Commands::CommandArgs)
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
