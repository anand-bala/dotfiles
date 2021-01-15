# originally implemented and transposed from https://github.com/patrickf3139/dotfiles/pull/11
function __fzf_search_current_dir --description "Search the current directory using fzf and fd. Insert the selected relative file path into the commandline at the cursor."
    set file_path_selected (
        eval $FZF_DEFAULT_COMMAND 2> /dev/null | fzf
    )

    if test $status -eq 0
        commandline --insert (echo $file_path_selected | string escape)
    end

    commandline --function repaint
end
