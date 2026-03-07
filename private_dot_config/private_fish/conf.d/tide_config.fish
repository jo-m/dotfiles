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

# Copied and modified from https://github.com/IlanCosman/tide/blob/main/functions/_tide_item_git.fish.
# Differences:
# - Do not display stashes and conflicted, and reorder
# - Operation names uppercase and with a ⚒ icon
function _tide_item_git_custom
    if git branch --show-current 2>/dev/null | string shorten -"$tide_git_truncation_strategy"m$tide_git_truncation_length | read -l location
        git rev-parse --git-dir --is-inside-git-dir | read -fL gdir in_gdir
        set location $_tide_location_color$location
    else if test $pipestatus[1] != 0
        return
    else if git tag --points-at HEAD | string shorten -"$tide_git_truncation_strategy"m$tide_git_truncation_length | read location
        git rev-parse --git-dir --is-inside-git-dir | read -fL gdir in_gdir
        set location '#'$_tide_location_color$location
    else
        git rev-parse --git-dir --is-inside-git-dir --short HEAD | read -fL gdir in_gdir location
        set location @$_tide_location_color$location
    end

    # Operation
    if test -d $gdir/rebase-merge
        # Turn ANY into ALL, via double negation
        if not path is -v $gdir/rebase-merge/{msgnum,end}
            read -f step <$gdir/rebase-merge/msgnum
            read -f total_steps <$gdir/rebase-merge/end
        end
        test -f $gdir/rebase-merge/interactive && set -f operation rebase-i || set -f operation rebase-m
    else if test -d $gdir/rebase-apply
        if not path is -v $gdir/rebase-apply/{next,last}
            read -f step <$gdir/rebase-apply/next
            read -f total_steps <$gdir/rebase-apply/last
        end
        if test -f $gdir/rebase-apply/rebasing
            set -f operation rebase
        else if test -f $gdir/rebase-apply/applying
            set -f operation am
        else
            set -f operation am/rebase
        end
    else if test -f $gdir/MERGE_HEAD
        set -f operation merge
    else if test -f $gdir/CHERRY_PICK_HEAD
        set -f operation cherry-pick
    else if test -f $gdir/REVERT_HEAD
        set -f operation revert
    else if test -f $gdir/BISECT_LOG
        set -f operation bisect
    end

    # Git status/stash + Upstream behind/ahead
    test $in_gdir = true && set -l _set_dir_opt -C $gdir/..
    # Suppress errors in case we are in a bare repo or there is no upstream
    set -l stat (git $_set_dir_opt --no-optional-locks status --porcelain 2>/dev/null)
    string match -qr '(0|(?<stash>.*))\n(0|(?<conflicted>.*))\n(0|(?<staged>.*))
(0|(?<dirty>.*))\n(0|(?<untracked>.*))(\n(0|(?<behind>.*))\t(0|(?<ahead>.*)))?' \
        "$(git $_set_dir_opt stash list 2>/dev/null | count
        string match -r ^UU $stat | count
        string match -r ^[ADMR] $stat | count
        string match -r ^.[ADMR] $stat | count
        string match -r '^\?\?' $stat | count
        git rev-list --count --left-right @{upstream}...HEAD 2>/dev/null)"

    if test -n "$operation$conflicted"
        set -g tide_git_bg_color $tide_git_bg_color_urgent
    else if test -n "$staged$dirty$untracked"
        set -g tide_git_bg_color $tide_git_bg_color_unstable
    end

    if test -n "$operation"
        set -f operation '⚒ '(string upper "$operation")
    end

    _tide_print_item git $_tide_location_color$tide_git_icon' ' (set_color white; echo -ns $location
        set_color $tide_git_color_upstream; echo -ns ' ⇣'$behind ' ⇡'$ahead
        set_color $tide_git_color_staged; echo -ns '● '
        set_color $tide_git_color_untracked; echo -ns '🞷 '
        set_color $tide_git_color_dirty; echo -ns '±'
        set_color $tide_git_color_operation; echo -ns ' '$operation ' '$step/$total_steps)
end

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
