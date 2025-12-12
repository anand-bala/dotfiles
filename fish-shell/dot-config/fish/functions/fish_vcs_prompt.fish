# Based on fish_jj_prompt and https://gist.github.com/hroi/d0dc0e95221af858ee129fd66251897e
function fish_jj_prompt
    # If jj isn't installed, there's nothing we can do
    # Return 1 so the calling prompt can deal with it
    if not command -sq jj
        return 1
    end
    set -l info "$(
        jj log 2>/dev/null --no-graph --ignore-working-copy --color=always --revisions @ \
            --template '
                surround(
                    "(",
                    ")",
                    separate(
                        " ",
                        bookmarks.join(", "),
                        change_id.short(8),
                        commit_id.short(8),
                        if(conflict, label("conflict", "×")),
                        if(divergent, label("divergent", "??")),
                        if(hidden, label("hidden prefix", "(hidden)")),
                        if(immutable, label("node immutable", "◆")),
                        coalesce(
                            if(
                                empty,
                                coalesce(
                                    if(
                                        parents.len() > 1,
                                        label("empty", "(merged)"),
                                    ),
                                    label("empty", "(empty)"),
                                ),
                            ),
                            label("description placeholder", "*")
                        ),
                    )
                )
            '
    )"
    or return 1
    if test -n "$info"
        printf '%s' $info
    end
end

function fish_vcs_prompt --description "Print all vcs prompts"
    # If a prompt succeeded, we assume that it's printed the correct info.
    # This is so we don't try svn if git already worked.
    fish_jj_prompt $argv
    or fish_git_prompt $argv
    # or fish_hg_prompt $argv
    # or fish_fossil_prompt $argv
    # The svn prompt is disabled by default because it's quite slow on common svn repositories.
    # To enable it uncomment it.
    # You can also only use it in specific directories by checking $PWD.
    # or fish_svn_prompt
end
