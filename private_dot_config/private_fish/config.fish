set -u fish_greeting ""

#
# Various
#

set -x EDITOR 'nano'

# code/codium compat
if type -q code
    set -u VSCODE_OR_CODIUM_COMMAND "code"
    set -u VSCODE_OR_CODIUM_EXTENSIONS "$HOME/.vscode/extensions"
    set -u VSCODE_OR_CODIUM_CONFIG_PATH "$HOME/.config/Code"
else
    alias code=codium
    set -u VSCODE_OR_CODIUM_COMMAND 'codium'
    set -u VSCODE_OR_CODIUM_EXTENSIONS "$HOME/.vscode-oss/extensions"
    set -u VSCODE_OR_CODIUM_CONFIG_PATH "$HOME/.config/VSCodium"
end

set -x FPP_EDITOR "$VSCODE_OR_CODIUM_COMMAND" # fpp http://facebook.github.io/PathPicker/

#
# Path
#

fish_add_path --path "$HOME/bin"

#
# Ripgrep
#

set -x RIPGREP_CONFIG_PATH $HOME/.config/ripgrep

#
# Go
#

set -x GOPATH "$HOME/go"
fish_add_path --path "$GOPATH/bin"

# custom per-machine config file
[ -f "$__fish_config_dir/_custom.fish" ]; and source "$__fish_config_dir/_custom.fish"

#
# NPM path
#

# https://github.com/sindresorhus/guides/blob/main/npm-global-without-sudo.md
# set up like this:
#   mkdir "$HOME/.npm-packages"
#   npm config set prefix "$HOME/.npm-packages"
#
# now, you can npm install -g without sudo.
set NPM_PACKAGES "$HOME/.npm-packages"
fish_add_path --path "$NPM_PACKAGES/bin"

# ddcutil
# needs: sudo usermod (whoami) -aG i2c
alias darker='ddcutil setvcp --display 2 0x10 - 25; ddcutil setvcp --display 1 0x10 - 25'
alias brighter='ddcutil setvcp --display 2 0x10 + 25; ddcutil setvcp --display 1 0x10 + 25'

#set -x IDF_TOOLS_PATH "$HOME/bin/espressif"
#set -x IDF_PATH "$HOME/bin/esp/v5.2.1/esp-idf"
#fish_add_path --path "$IDF_PATH/tools"
# test -f "$IDF_PATH/export.fish" && source $IDF_PATH/export.fish
