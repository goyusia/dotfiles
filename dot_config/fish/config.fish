# Put system-wide fish configuration entries here
# or in .fish files in conf.d/
# Files in conf.d can be overridden by the user
# by files with the same name in $XDG_CONFIG_HOME/fish/conf.d

# This file is run by all fish instances.
# To include configuration only for login shells, use
# if status is-login
#    ...
# end
# To include configuration only for interactive shells, use
# if status is-interactive
#   ...
# end

# desktop은 cachyos default base
if test (hostname) = haruna; and test (id -un) = goyusia
    source /usr/share/cachyos-fish-config/cachyos-config.fish
    exit
end

## Set values
## Run fastfetch as welcome message
function fish_greeting
    fastfetch
end

fish_add_path ~/bin

## Useful aliases
# Replace ls with eza
alias ls='eza -al --color=always --group-directories-first --icons=always' # preferred listing
alias la='eza -a --color=always --group-directories-first --icons=always'  # all files and dirs
alias ll='eza -l --color=always --group-directories-first --icons=always'  # long format
alias lt='eza -aT --color=always --group-directories-first --icons=always' # tree listing
alias l.="eza -a | grep -e '^\.'"                                     # show only dotfiles

# mise 같은건 설치된 환경에서만 활성화 하고 싶다.
# 일단은 무식하게 감지하도록 구현
if test (hostname) = miyo; and test (id -un) = miyo
    /home/miyo/.local/bin/mise activate fish | source
end
