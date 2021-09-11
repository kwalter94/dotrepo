module Dotfiles::Exceptions
  class Exception < ::Exception; end

  class ImportFailed < Exception; end

  class ExportFailed < Exception; end
end
