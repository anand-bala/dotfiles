function _fish_python_prompt
    if test -n "$VIRTUAL_ENV"
        if command -q python3
            python3 --version | string match -qr "(?<v>[\d.]+)"
        else
            python --version | string match -qr "(?<v>[\d.]+)"
        end
        string match -qr "^.*/(?<dir>.*)/(?<base>.*)" $VIRTUAL_ENV
        set -l venv_name
        if contains -- "$base" virtualenv venv .venv env # avoid generic names
            set venv_name $dir
        else
            set venv_name $base
        end
        echo "(󰌠  $v @ $venv_name)"
    else if test -n "$PIXI_PROJECT_NAME" -a -n "$PIXI_ENVIRONMENT_NAME"
        if command -q python3
            python3 --version | string match -qr "(?<v>[\d.]+)"
        else
            python --version | string match -qr "(?<v>[\d.]+)"
        end
        set -l venv_name "$PIXI_PROJECT_NAME/$PIXI_ENVIRONMENT_NAME"
        echo "(󰌠  $v @ $venv_name)"
    else if path is .python-version Pipfile __init__.py pyproject.toml requirements.txt setup.py
        if command -q python3
            python3 --version | string match -qr "(?<v>[\d.]+)"
        else
            python --version | string match -qr "(?<v>[\d.]+)"
        end
        echo "(󰌠  $v)"
    end
end
