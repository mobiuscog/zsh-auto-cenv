function _activate_cenv() {
    local cenv_file="$1"
    local cenv_name
    cenv_name=$(grep -m2 'name:' "$cenv_file" | tail -1 | awk '{print $2}')

    if [[ -z "$CONDA_PREFIX" || "*$cenv_name" != "$VIRTUAL_ENV" ]]; then
        conda activate "$cenv_name" 2>1 >/dev/null
    fi
}

function _deactivate_cenv() {
    if [[ -n "$CONDA_PREFIX" ]]; then
        conda deactivate
    fi
}

function _check_cenv_path()
{
    local check_dir="$1"

    if [[ -f "${check_dir}/environment.yaml" ]]; then
        printf "${check_dir}/environment.yaml"
        return
    elif [[ -f "${check_dir}/environment.yml" ]]; then
        printf "${check_dir}/environment.yml"
        return
    else
        if [[ "$check_dir" = "/" || "$check_dir" = "$HOME" ]]; then
            return
        fi
        _check_cenv_path "$(dirname "$check_dir")"
    fi
}

function _check_cenv()
{
    local cenv_path
    cenv_path="$(_check_cenv_path "$PWD")"

    if [[ -n "$cenv_path" ]]; then
        _activate_cenv "$cenv_path"
    else
        _deactivate_cenv
    fi
}

autoload -Uz add-zsh-hook
add-zsh-hook chpwd _check_cenv

_check_cenv
