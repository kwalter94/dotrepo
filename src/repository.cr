module Dotrepo::Repository
  extend self

  def path
    return Path["DOTFILES_REPOSITORY"] if ENV.has_key?("DOTFILES_REPOSITORY")

    Path.home.join(".dotfiles")
  end
end
