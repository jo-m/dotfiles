# In order for this theme to render correctly, you will need a
# [Powerline-patched font](https://gist.github.com/1595572).

set -g current_bg NONE
set segment_separator \uE0B0
set right_segment_separator \uE0B0

# ===========================
# Color setting

# You can set these variables in config.fish like:
# set -g color_dir_bg red
# If not set, default color from agnoster will be used.
# ===========================

set -q color_virtual_env_bg; or set color_virtual_env_bg magenta
set -q color_virtual_env_str; or set color_virtual_env_str black
set -q color_hostname_bg; or set color_hostname_bg yellow
set -q color_hostname_str; or set color_hostname_str black
set -q color_user_bg; or set color_user_bg blue
set -q color_user_str; or set color_user_str white
set -q color_dir_bg; or set color_dir_bg green
set -q color_dir_str; or set color_dir_str white
set -q color_git_bg; or set color_git_bg red
set -q color_git_str; or set color_git_str white
set -q color_status_bg; or set color_status_bg black
set -q color_status_str; or set color_status_str yellow

set -q color_status_nonzero_bg; or set color_status_nonzero_bg red
set -q color_status_nonzero_str; or set color_status_nonzero_str white

# ===========================
# Helper methods
# ===========================

# returns 0 if we are in a container
function running_in_docker
    [ -f /.dockerenv ] || return 1
    return 0
end

function inside_git_dir
    git rev-parse --is-inside-work-tree >/dev/null 2>&1
    return $status
end

function git_dir_is_dirty
    set -l git_status (git status --porcelain --ignore-submodules=none 2>/dev/null)
    test -n "$git_status"
    return $status
end

function git_on_branch
    set -l git_status (git branch --show-current 2>/dev/null)
    test -n "$git_status"
    return $status
end

# ===========================
# Segments functions
# ===========================

function prompt_segment -d "Function to draw a segment"
    set -l bg
    set -l fg
    if [ -n "$argv[1]" ]
        set bg $argv[1]
    else
        set bg normal
    end
    if [ -n "$argv[2]" ]
        set fg $argv[2]
    else
        set fg normal
    end
    if [ "$current_bg" != 'NONE' -a "$argv[1]" != "$current_bg" ]
        set_color -b $bg
        set_color $current_bg
        echo -n "$segment_separator"
        set_color -b $bg
        set_color $fg
    else
        set_color -b $bg
        set_color $fg
    end
    set current_bg $argv[1]
    if [ -n "$argv[3]" ]
        echo -n -s $argv[3]
    end
end

function prompt_finish -d "Close open segments"
    if [ -n $current_bg ]
        # spacing at the end?
        # echo -n ' '
        set_color normal
        set_color $current_bg
        echo -n "$segment_separator "
        set_color normal
    end
    set -g current_bg NONE
end


# ===========================
# Theme components
# ===========================

set -x VIRTUAL_ENV_DISABLE_PROMPT 'yes'
function prompt_virtual_env -d "Display Python virtual environment"
    if test "$VIRTUAL_ENV"
        set py_env (basename $VIRTUAL_ENV)
        prompt_segment $color_virtual_env_bg $color_virtual_env_str " $py_env "
    end
end

function prompt_user -d "Display current user if different from $default_user"
    prompt_segment $color_user_bg $color_user_str (whoami)
end

function prompt_hostname -d "Display hostname with optional SSH and Docker info"
    if [ -n "$SSH_CONNECTION" ]
        then
        set hostname_prompt "@$hostname"
    else if running_in_docker
        set hostname_prompt "🐳 "
    else
        set hostname_prompt "~$hostname"
    end
    prompt_segment $color_hostname_bg $color_hostname_str " $hostname_prompt"
end

function prompt_dir -a allowed_max_len -d "Display the current directory"
    if test (string length (prompt_pwd)) -gt "$allowed_max_len"
        set -g fish_prompt_pwd_dir_length 2
    else
        set -g fish_prompt_pwd_dir_length 0
    end
    set display_pwd (prompt_pwd)

    prompt_segment $color_dir_bg $color_dir_str " $display_pwd"
end

set __git_dirty_sym '±' # Unicode PLUS-MINUS SIGN
set __git_staged_sym '⬤' # Unicode BLACK LARGE CIRCLE (Old: ⬤)
set __git_staged_sym '● ' # Unicode BLACK CIRCLE (Old: ✱)
set __git_unstaged_sym '🞷 ' # Unicode BOLD SIX SPOKED ASTERISK
set __git_branch_sym \uE0A0 # Powerline BRANCH SYMBOL 
set __git_detached_sym '➦' # Unicode HEAVY BLACK CURVED UPWARDS AND RIGHTWARDS ARROW
set __git_operation_sym '⚒ ' # Unicode HAMMER AND PICK
# set __git_untracked_sym '✸' # 🗙 ❋ ❇

function prompt_git -d "Display the current git state"
    if not inside_git_dir
        return 0
    end

    # those are unset
    set -e __fish_git_prompt_show_informative_status
    set -e __fish_git_prompt_showupstream

    # dirty
    set -g __fish_git_prompt_showdirtystate true
    set -g __fish_git_prompt_char_dirtystate "$__git_unstaged_sym"
    set -g __fish_git_prompt_char_stagedstate "$__git_staged_sym"

    # # untracked
    # set -g __fish_git_prompt_showuntrackedfiles true
    # set -g __fish_git_prompt_char_untrackedfiles "$__git_untracked_sym"

    # ref display
    set -g __fish_git_prompt_describe_style branch

    # get fish git info
    set -l git_info (string replace "|" " $__git_operation_sym" (fish_git_prompt "%s"))

    # add dirty sign
    if git_dir_is_dirty
        set git_info "$__git_dirty_sym$git_info"
    end

    if git_on_branch
        set git_info "$__git_branch_sym $git_info"
    else
        set git_info "$__git_detached_sym $git_info"
    end

    prompt_segment $color_git_bg $color_git_str " $git_info"
end



function prompt_status -d "the symbols for a non zero exit status, root and background jobs"
    if [ "$fish_private_mode" ]
        prompt_segment $color_status_bg $color_status_str "🙈🙉🙊 "
    end

    # if superuser (uid == 0)
    set -l uid (id -u $USER)
    if [ $uid -eq 0 ]
        prompt_segment $color_status_bg $color_status_str "⚡ "
    end

    # Jobs display
    if [ (jobs -l | wc -l) -gt 0 ]
        prompt_segment $color_status_bg $color_status_str "⚙ "
    end
end

# ===========================
# Apply theme
# ===========================

function fish_prompt
    set -g __LAST_CMD_RETVAL $status

    # calculate max allowed length for user, hostname and dir
    set -l user_hostname_dir_allowed_max_len (math --scale=0 $COLUMNS / 2 - 15)
    if test "$user_hostname_dir_allowed_max_len" -lt 10
        set user_hostname_dir_allowed_max_len 10
    end
    set -l user_len (string length (whoami))
    set -l host_len (string length (hostname))
    set -g fish_prompt_pwd_dir_length 0
    set -l dir_len (string length (prompt_pwd))
    set -l total_len (math "$user_len + $host_len + $dir_len")
    if test "$total_len" -gt "$user_hostname_dir_allowed_max_len"
        set disable_user 1
        set total_len (math "$total_len - $user_len")
    end
    if test "$total_len" -gt "$user_hostname_dir_allowed_max_len"
        set disable_hostname 1
        set total_len (math "$total_len - $host_len")
    end
    set dir_allowed_max_len 1000
    if test "$total_len" -gt "$user_hostname_dir_allowed_max_len"
        set dir_allowed_max_len (math "$user_hostname_dir_allowed_max_len - $total_len")
        if test "$dir_allowed_max_len" -lt 10
            set dir_allowed_max_len 10
        end
    end

    prompt_status
    set -q disable_user; or prompt_user
    set -q disable_hostname; or prompt_hostname
    prompt_dir "$dir_allowed_max_len"
    type -q git; and prompt_git
    prompt_virtual_env
    prompt_finish
end

function fish_right_prompt -d "Write out the right prompt"
    # show error status
    if [ $__LAST_CMD_RETVAL -ne 0 ]
        set_color -b $color_status_nonzero_bg
        set_color $color_status_nonzero_str
        echo "$__LAST_CMD_RETVAL ↵ "
        set_color -b normal
        set_color normal
    end
end
