# Fish completions for dotrepo

complete -c dotrepo -s h -l help -d 'Print help information and exit'
complete -c dotrepo -s v -l version -d 'Print version information and exit'

complete -c dotrepo -a export -n __fish_use_subcommand -d 'Export files in repository to user directory'
complete -c dotrepo -a import -r -n __fish_use_subcommand -d 'Import files into repository from user directory'
complete -c dotrepo -a path -n __fish_use_subcommand --no-files -d 'Print path to repository'
complete -c dotrepo -a ls -n __fish_use_subcommand -d 'Lists files in repository'
