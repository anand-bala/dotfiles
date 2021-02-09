set --query fisher_path; or set -gx fisher_path ~/.local/share/fisher

contains -- $fisher_path/functions $fish_function_path
or set fish_function_path $fish_function_path[1] $fisher_path/functions $fish_function_path[2..-1]

contains -- $fisher_path/completions $fish_complete_path
or set fish_complete_path $fish_complete_path[1] $fisher_path/completions $fish_complete_path[2..-1]

for file in $fisher_path/conf.d/*.fish
    source $file
end
