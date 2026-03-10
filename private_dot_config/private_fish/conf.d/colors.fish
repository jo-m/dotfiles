# https://fishshell.com/docs/current/interactive.html#syntax-highlighting
#
#     fish_config theme show current
set --global fish_color_normal                         white
set --global fish_color_command                        normal --bold
set --global fish_color_keyword                        '' # Default to fish_color_command.
set --global fish_color_quote                          yellow
set --global fish_color_redirection                    cyan --bold
set --global fish_color_end                            green
set --global fish_color_error                          brred
set --global fish_color_param                          normal
set --global fish_color_valid_path                     --underline
set --global fish_color_option                         '' # default to fish_color_param.
set --global fish_color_comment                        brblack
set --global fish_color_selection                      white --bold --background=brblack
set --global fish_color_operator                       brcyan
set --global fish_color_escape                         brcyan
set --global fish_color_autosuggestion                 brblack
set --global fish_color_cwd                            green
set --global fish_color_cwd_root                       red
set --global fish_color_user                           brgreen
set --global fish_color_host                           normal
set --global fish_color_host_remote                    normal
set --global fish_color_status                         ''
set --global fish_color_cancel                         --reverse
set --global fish_color_search_match                   bryellow --background=brblack
set --global fish_color_history_current                --bold

# https://fishshell.com/docs/current/interactive.html#pager-color-variables
# Note: those are not currently in use because we use fzf for paging.
set --global fish_pager_color_progress                 brwhite --background=cyan
set --global fish_pager_color_background               ''
set --global fish_pager_color_prefix                   normal --bold --underline
set --global fish_pager_color_completion               normal
set --global fish_pager_color_description              yellow --italics
set --global fish_pager_color_selected_background      --reverse
set --global fish_pager_color_selected_prefix          ''
set --global fish_pager_color_selected_completion      ''
set --global fish_pager_color_selected_description     ''
set --global fish_pager_color_secondary_background     ''
set --global fish_pager_color_secondary_prefix         ''
set --global fish_pager_color_secondary_completion     ''
set --global fish_pager_color_secondary_description    ''
