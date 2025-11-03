# Fish completion for rory-terminal

# Themes
set -l themes halloween christmas easter hacker matrix

# rory-terminal completions
complete -c rory-terminal -f
complete -c rory-terminal -n "__fish_use_subcommand" -a install -d "Install Rory Terminal integration"
complete -c rory-terminal -n "__fish_use_subcommand" -a theme -d "Manage terminal themes"
complete -c rory-terminal -n "__fish_use_subcommand" -a matrix -d "Run Matrix animation"
complete -c rory-terminal -n "__fish_use_subcommand" -a gui -d "Open GUI theme selector"
complete -c rory-terminal -n "__fish_use_subcommand" -a help -d "Show help information"
complete -c rory-terminal -n "__fish_use_subcommand" -a version -d "Show version information"

# theme subcommand
complete -c rory-terminal -n "__fish_seen_subcommand_from theme; and not __fish_seen_subcommand_from set list current" -a set -d "Set active theme"
complete -c rory-terminal -n "__fish_seen_subcommand_from theme; and not __fish_seen_subcommand_from set list current" -a list -d "List available themes"
complete -c rory-terminal -n "__fish_seen_subcommand_from theme; and not __fish_seen_subcommand_from set list current" -a current -d "Show current theme"

# theme set completion
complete -c rory-terminal -n "__fish_seen_subcommand_from theme; and __fish_seen_subcommand_from set" -a "$themes"

# matrix subcommand completion
complete -c rory-terminal -n "__fish_seen_subcommand_from matrix" -a "$themes"

# rory-theme completions
complete -c rory-theme -f
complete -c rory-theme -n "not __fish_seen_subcommand_from set list current enable-starship disable-starship" -a set -d "Set active theme"
complete -c rory-theme -n "not __fish_seen_subcommand_from set list current enable-starship disable-starship" -a list -d "List available themes"
complete -c rory-theme -n "not __fish_seen_subcommand_from set list current enable-starship disable-starship" -a current -d "Show current theme"
complete -c rory-theme -n "not __fish_seen_subcommand_from set list current enable-starship disable-starship" -a enable-starship -d "Enable Starship integration"
complete -c rory-theme -n "not __fish_seen_subcommand_from set list current enable-starship disable-starship" -a disable-starship -d "Disable Starship integration"

complete -c rory-theme -n "__fish_seen_subcommand_from set" -a "$themes"

# rory-matrix completions
complete -c rory-matrix -f -a "$themes"
