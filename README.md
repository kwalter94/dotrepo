[![.github/workflows/test.yml](https://github.com/kwalter94/dotrepo/actions/workflows/test.yml/badge.svg)](https://github.com/kwalter94/dotrepo/actions/workflows/test.yml)

# dotrepo

This is a tool for managing a repository of a user's dotfiles. It organises a user's
dotfiles in a single directory and creates symbolic links to these dotfiles where
the dotfiles are normally located. For example `~/.config/nvim/init.vim`
and `~/.config/fish/config.fish` are replaced with symbolic links
to `~/.dotrepo/.config/nvim/init.vim` and `~/.dotrepo/.config/fish/config.fish`
respectively. A user can then check ~/.dotrepo into version control.

## Building

The following are required to build the application:

  - [crystal](https://crystal-lang.org/install/) version 0.36.1 or higher
  - [Optional] [asdf](https://github.com/asdf-community/asdf-crystal) - can be used to install the above

Once you have the crystal compiler setup and have this repository cloned to your machine,
run the following command at the root of the repository:

  ```sh
  crystal spec
  ```

You should get an output that looks something like:

    Finished in 3.7 milliseconds
    12 examples, 0 failures, 0 errors, 0 pending
  
If you get no output then you are probably in the wrong directory but crystal is properly
setup. Otherwise, ensure that no failures are reported. To build the application,
run the following command in the same directory:

  ```sh
  crystal build src/dotrepo.cr --release
  ```

This produces a `dotrepo` binary in the your current working directory. You should move
this binary to your binaries directory (eg ~/bin).

## Usage

```sh
dotrepo help  # Displays usage instructions

dotrepo ls  # Lists all files in repository

dotrepo import [path] # Imports file at path into dotfile repository

dotrepo export  # Exports everything in repository to user directory

dotrepo export [repository-path] # Exports specific file from repository to user directory

dotrepo path # Prints out path of the dotfiles repository
```

There are three primary commands that are provided: import, export, and ls. All these
commands operate on the dotfile repository. The default path for the dotfiles repository
is `~/.dotfiles`, however this can be overriden through the environment variable
`DOTFILES_REPOSITORY`.

## Contributing

1. Fork it (<https://github.com/your-github-user/dotfiles/fork>)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

You may want to adhere to
[this](https://crystal-lang.org/reference/conventions/coding_style.html) style guide.
And please, with every feature try to include unit tests for the feature. For bugs
fixes, it is also recommended that you include a unit test that replicates the bug
if possible.

## Contributors

- [kwalter](https://github.com/your-github-user) - creator and maintainer
