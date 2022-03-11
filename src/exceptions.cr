module Dotrepo::Exceptions
  class Exception < ::Exception
    def initialize(cause : ::Exception)
      super(nil, cause)
    end

    def initialize(message : String)
      super(message)
    end

    def initialize(message : String, cause : ::Exception)
      super(message, cause)
    end

    def to_s(io : IO)
      io << "#{message} - #{cause}" if cause && message

      io << cause.to_s if cause

      super(io)
    end
  end

  class ImportFailed < Exception; end

  class ExportFailed < Exception; end
end
