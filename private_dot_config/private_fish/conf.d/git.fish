# Git wrapper to fallback from main to master if main branch is not found
function git --description 'Git wrapper to fallback from main to master (supports checkout and co)'
    # Check if we have at least 2 arguments (command and branch)
    if test (count $argv) -ge 2
        set -l sub_cmd $argv[1]
        set -l branch $argv[2]

        # Intercept if command is 'checkout' or 'co' AND the target is 'main'
        if contains $sub_cmd checkout co; and test "$branch" = "main"
            # Check if 'main' exists locally or on a remote
            if not command git rev-parse --verify main >/dev/null 2>&1
                echo (set_color yellow)"⚠️  'main' not found, falling back to 'master'..."(set_color normal)
                
                # Replace 'main' with 'master' but keep all other flags
                set -e argv[2]
                command git $sub_cmd master $argv[2..-1]
                return
            end
        end
    end

    # Default: Pass everything to the real git command
    command git $argv
end
