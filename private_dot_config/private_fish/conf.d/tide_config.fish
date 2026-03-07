# https://github.com/IlanCosman/tide/wiki/Configuration#prompt-variables
# https://github.com/IlanCosman/tide/tree/main/functions

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

# TODO:
# Copied and modified from https://github.com/IlanCosman/tide/blob/main/functions/_tide_item_git.fish.
# Differences:
# - Do not display stashes and conflicted
# - Operation names uppercase and with a ⚒ icon, and displayed last
# set __git_dirty_sym '±' # Unicode PLUS-MINUS SIGN
# set __git_staged_sym '● ' # Unicode BLACK CIRCLE (Old: ✱)
# set __git_unstaged_sym '🞷 ' # Unicode BOLD SIX SPOKED ASTERISK
# set __git_branch_sym \uE0A0 # Powerline BRANCH SYMBOL 
# set __git_detached_sym '➦' # Unicode HEAVY BLACK CURVED UPWARDS AND RIGHTWARDS ARROW

#
# Global settings
#

# We do not use this directly in a prompt, but it is used by the transient prompt.
set --global tide_character_color                        yellow
set --global tide_character_color_failure                yellow
if [ (id -u) -eq 0 ]
    set --global tide_character_icon                     "$hostname #"
else
    set --global tide_character_icon                     "$hostname \$"
end

set --global tide_prompt_add_newline_before             false
set --global tide_prompt_color_frame_and_connection     brblack
set --global tide_prompt_color_separator_same_color     brblack
set --global tide_prompt_pad_items                      false
set --global tide_prompt_transient_enabled              true

# Left prompt
set --global tide_left_prompt_items                     private_mode superuser jobs username hostname pwd git direnv rustc go python
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

set --global tide_private_mode_bg_color    black
set --global tide_private_mode_color       yellow
set --global tide_private_mode_icon        "🙈🙉🙊"

set --global tide_superuser_bg_color       black
set --global tide_superuser_color          yellow
set --global tide_superuser_icon           '⚡'

set --global tide_jobs_bg_color            black
set --global tide_jobs_color               yellow
set --global tide_jobs_icon                '⚙'

#
# Rest of left prompt
#

set --global tide_username_bg_color       blue
set --global tide_username_color          white
set --global tide_username_icon           ''

set --global tide_hostname_bg_color       yellow
set --global tide_hostname_color          black
set --global tide_hostname_icon           ''

# PWD
set --global tide_pwd_bg_color               green
set --global tide_pwd_color_anchors          white
set --global tide_pwd_color_dirs             white
set --global tide_pwd_color_truncated_dirs   white
set --global tide_pwd_icon                   ''
set --global tide_pwd_icon_home              ''
set --global tide_pwd_icon_unwritable        '🚫'
set --global tide_pwd_markers                .git Cargo.toml go.mod package.json

# Git
set --global tide_git_bg_color               red
set --global tide_git_bg_color_unstable      red
set --global tide_git_bg_color_urgent        red
set --global tide_git_color_branch           white
set --global tide_git_color_conflicted       white
set --global tide_git_color_dirty            white
set --global tide_git_color_operation        white
set --global tide_git_color_staged           white
set --global tide_git_color_stash            white
set --global tide_git_color_untracked        white
set --global tide_git_color_upstream         white
set --global tide_git_icon                   ''
set --global tide_git_truncation_length      100
set --global tide_git_truncation_strategy    'l' # Left

# Directory environment
set --global tide_direnv_bg_color            white
set --global tide_direnv_bg_color_denied     white
set --global tide_direnv_color               black
set --global tide_direnv_color_denied        red
set --global tide_direnv_icon                '🐚'

set --global tide_rustc_bg_color             white
set --global tide_rustc_color                black
set --global tide_rustc_icon                 '🦀'

set --global tide_go_bg_color                white
set --global tide_go_color                   black
set --global tide_go_icon                    '🐹'

set --global tide_python_bg_color           white
set --global tide_python_color              black
set --global tide_python_icon               '🐍'

#
# Right prompt
#

# Status
set --global tide_status_bg_color           black
set --global tide_status_bg_color_failure   red
set --global tide_status_color              green
set --global tide_status_color_failure      white
set --global tide_status_icon               ''
set --global tide_status_icon_failure       '↵ '

# Command duration
set --global tide_cmd_duration_bg_color     yellow
set --global tide_cmd_duration_color        black
set --global tide_cmd_duration_icon         '⏱'
set --global tide_cmd_duration_threshold    2000 # ms
