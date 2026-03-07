# https://github.com/IlanCosman/tide/wiki/Configuration#prompt-variables
# https://github.com/IlanCosman/tide/tree/main/functions

# In order for this to render correctly, you will need a
# [Powerline-patched font](https://gist.github.com/1595572).

#
# Theme colors
# https://fishshell.com/docs/current/cmds/set_color.html
#

# 16 colors
set --local _prompt_colors_black     black
set --local _prompt_colors_blue      blue
set --local _prompt_colors_brblack   brblack
set --local _prompt_colors_green     green
set --local _prompt_colors_red       red
set --local _prompt_colors_white     white
set --local _prompt_colors_yellow    yellow

# Full colors
set --local _prompt_colors_black     '#303030'
set --local _prompt_colors_blue      '#1581FF'
set --local _prompt_colors_brblack   '#787878'
set --local _prompt_colors_green     '#6AB017'
set --local _prompt_colors_red       '#E1321A'
set --local _prompt_colors_white     '#F2F2F2'
set --local _prompt_colors_yellow    '#FFC005'

#
# Custom segment items
#

function _tide_item_superuser
    if [ (id -u) -eq 0 ]
        _tide_print_item   superuser        $tide_superuser_icon' '
    end
end

function _tide_item_username
    _tide_print_item   username             "$USER"
end

function _tide_item_hostname
    if [ -n "$SSH_CONNECTION" ]
        _tide_print_item   hostname         " @$hostname"
    else
        _tide_print_item   hostname         " ~$hostname"
    end
end

#
# Git segment
#

function _tide_item_git_custom_inside_git_dir
    git rev-parse --is-inside-work-tree >/dev/null 2>&1
    return $status
end

function _tide_item_git_custom_git_on_branch
    set -l git_status (git branch --show-current 2>/dev/null)
    test -n "$git_status"
    return $status
end

# https://fishshell.com/docs/current/cmds/fish_git_prompt.html
function _tide_item_git_custom
    if not _tide_item_git_custom_inside_git_dir
        return 0
    end

    set --global __fish_git_prompt_show_informative_status   false
    set --global __fish_git_prompt_use_informative_chars     true
    set --global __fish_git_prompt_showuntrackedfiles        true
    set --global __fish_git_prompt_showdirtystate            true
    set --global __fish_git_prompt_showupstream              auto

    set --global __fish_git_prompt_showstashstate            false
    set --global __fish_git_prompt_shorten_branch_len        50
    set --global __fish_git_prompt_describe_style            branch
    set --global __fish_git_prompt_char_stateseparator       ''

    set --global __fish_git_prompt_char_cleanstate           '✔ '
    set --global __fish_git_prompt_char_dirtystate           '±'   # Unicode PLUS-MINUS SIGN
    set --global __fish_git_prompt_char_invalidstate         '✖ '
    set --global __fish_git_prompt_char_stagedstate          '● ' # Unicode BOLD SIX SPOKED ASTERISK
    set --global __fish_git_prompt_char_stashstate           ''
    set --global __fish_git_prompt_char_untrackedfiles       '🞷 ' # Unicode BLACK CIRCLE
    set --global __fish_git_prompt_char_upstream_ahead       '↑ '
    set --global __fish_git_prompt_char_upstream_behind      '↓ '
    set --global __fish_git_prompt_char_upstream_diverged    '↓↑ '
    set --global __fish_git_prompt_char_upstream_equal       ''
    set --global __fish_git_prompt_char_upstream_prefix      ''
    set --local _tide_item_git_custom_operation_sym          '⚒ ' # Unicode HAMMER AND PICK
    set --local _tide_item_git_custom_branch_sym             '' # Powerline BRANCH SYMBOL
    set --local _tide_item_git_custom_detached_sym           '➦' # Unicode HEAVY BLACK CURVED UPWARDS AND RIGHTWARDS ARROW
    # set __fish_git_prompt_char_untrackedfiles '✸' # 🗙 ❋ ❇

    set --local git_info (string replace "|" " $_tide_item_git_custom_operation_sym" (fish_git_prompt "%s"))

    if _tide_item_git_custom_git_on_branch
        set git_info "$_tide_item_git_custom_branch_sym $git_info"
    else
        set git_info "$_tide_item_git_custom_detached_sym $git_info"
    end

    _tide_print_item git "$_tide_location_color$tide_git_icon "(
        set_color $tide_git_color_upstream;
        echo -ns $git_info)
end

#
# Global settings
#

# We do not use this directly in a prompt, but it is used by the transient prompt.
set --global tide_character_color                       $_prompt_colors_yellow
set --global tide_character_color_failure               $_prompt_colors_yellow
if [ (id -u) -eq 0 ]
    set --global tide_character_icon                    "$hostname #"
else
    set --global tide_character_icon                    "$hostname \$"
end

set --global tide_prompt_add_newline_before             false
set --global tide_prompt_color_frame_and_connection     $_prompt_colors_brblack
set --global tide_prompt_color_separator_same_color     $_prompt_colors_brblack
set --global tide_prompt_pad_items                      false
set --global tide_prompt_transient_enabled              true

# Left prompt
set --global tide_left_prompt_items                     private_mode superuser jobs username hostname pwd git_custom direnv rustc go python
set --global tide_left_prompt_separator_same_color      '❯'
set --global tide_left_prompt_separator_diff_color      '' #      
set --global tide_left_prompt_prefix                    ''
set --global tide_left_prompt_suffix                    ''

# Right prompt
set --global tide_right_prompt_items                    status cmd_duration
set --global tide_right_prompt_prefix                   ''
set --global tide_right_prompt_suffix                   ''
set --global tide_right_prompt_separator_same_color     ''
set --global tide_right_prompt_separator_diff_color     ''

#
# Status
#

set --global tide_private_mode_bg_color     $_prompt_colors_black
set --global tide_private_mode_color        $_prompt_colors_yellow
set --global tide_private_mode_icon         "🙈🙉🙊"

set --global tide_superuser_bg_color        $_prompt_colors_black
set --global tide_superuser_color           $_prompt_colors_yellow
set --global tide_superuser_icon            '⚡'

set --global tide_jobs_bg_color             $_prompt_colors_black
set --global tide_jobs_color                $_prompt_colors_yellow
set --global tide_jobs_icon                 '⚙'

#
# Rest of left prompt
#

set --global tide_username_bg_color         $_prompt_colors_blue
set --global tide_username_color            $_prompt_colors_white
set --global tide_username_icon             ''

set --global tide_hostname_bg_color         $_prompt_colors_yellow
set --global tide_hostname_color            $_prompt_colors_black
set --global tide_hostname_icon             ''

# PWD
set --global tide_pwd_bg_color              $_prompt_colors_green
set --global tide_pwd_color_anchors         $_prompt_colors_white
set --global tide_pwd_color_dirs            $_prompt_colors_white
set --global tide_pwd_color_truncated_dirs  $_prompt_colors_white
set --global tide_pwd_icon                  ''
set --global tide_pwd_icon_home             ''
set --global tide_pwd_icon_unwritable       '🚫'
set --global tide_pwd_markers               .git Cargo.toml go.mod package.json

# Git
set --global tide_git_bg_color              $_prompt_colors_red
set --global tide_git_bg_color_unstable     $_prompt_colors_red
set --global tide_git_bg_color_urgent       $_prompt_colors_red
set --global tide_git_color                 $_prompt_colors_white
set --global tide_git_color_branch          $_prompt_colors_white
set --global tide_git_color_conflicted      $_prompt_colors_white
set --global tide_git_color_dirty           $_prompt_colors_white
set --global tide_git_color_operation       $_prompt_colors_white
set --global tide_git_color_staged          $_prompt_colors_white
set --global tide_git_color_stash           $_prompt_colors_white
set --global tide_git_color_untracked       $_prompt_colors_white
set --global tide_git_color_upstream        $_prompt_colors_white
set --global tide_git_icon                  ''
set --global tide_git_truncation_length     100
set --global tide_git_truncation_strategy   'l' # Left

# Directory environment
set --global tide_direnv_bg_color           $_prompt_colors_white
set --global tide_direnv_bg_color_denied    $_prompt_colors_white
set --global tide_direnv_color              $_prompt_colors_black
set --global tide_direnv_color_denied       $_prompt_colors_red
set --global tide_direnv_icon               '🐚'

set --global tide_rustc_bg_color            $_prompt_colors_white
set --global tide_rustc_color               $_prompt_colors_black
set --global tide_rustc_icon                '🦀'

set --global tide_go_bg_color               $_prompt_colors_white
set --global tide_go_color                  $_prompt_colors_black
set --global tide_go_icon                   '🐹'

set --global tide_python_bg_color           $_prompt_colors_white
set --global tide_python_color              $_prompt_colors_black
set --global tide_python_icon               '🐍'

#
# Right prompt
#

# Status
set --global tide_status_bg_color           $_prompt_colors_black
set --global tide_status_bg_color_failure   $_prompt_colors_red
set --global tide_status_color              $_prompt_colors_green
set --global tide_status_color_failure      $_prompt_colors_white
set --global tide_status_icon               ''
set --global tide_status_icon_failure       '↵ '

# Command duration
set --global tide_cmd_duration_bg_color     $_prompt_colors_yellow
set --global tide_cmd_duration_color        $_prompt_colors_black
set --global tide_cmd_duration_icon         '⏱'
set --global tide_cmd_duration_threshold    2000 # ms
