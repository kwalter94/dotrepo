module Dotfiles::Exceptions
  class Exception < ::Exception; end

  class ImportFailed < Exception; end
end
