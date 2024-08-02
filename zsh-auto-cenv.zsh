function _activate_cenv() {
    local cenv_file="$1"
    local cenv_name
    cenv_name=$(grep -m2 'name:' "$cenv_file" | tail -1 | awk '{print $2}')

    # Don't reactivate an already activated virtual environment
    if [[ -z "$CONDA_PREFIX" || "*$cenv_name" != "$VIRTUAL_ENV" ]]; then
        conda activate "$cenv_name"
    fi
}

function _deactivate_cenv() {
    if [[ -n "$CONDA_PREFIX" ]]; then
        conda deactivate
    fi
}

# Gives the path to the nearest target file
function _check_cenv_path()
{
    local check_dir="$1"
    local check_file="$2"

    if [[ -d "${check_dir}/$check_file" ]]; then
        printf "${check_dir}/$check_file"
        return
    else
        # Abort search at file system root or HOME directory (latter is a performance optimisation).
        if [[ "$check_dir" = "/" || "$check_dir" = "$HOME" ]]; then
            return
        fi
        _check_cenv_path "$(dirname "$check_dir")" "$check_file"
    fi
}

function _check_cenv()
{
    local cenv_path
    cenv_path="$(_check_cenv_path "$PWD" "environment.yaml")"

    if [[ -n "$cenv_path" ]]; then
        _activate_cenv "$cenv_path"
    else
        _deactivate_cenv
    fi
}

autoload -Uz add-zsh-hook
add-zsh-hook chpwd _check_cenv

_check_cenv
