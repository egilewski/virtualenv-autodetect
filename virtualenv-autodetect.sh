# virtualenv-autodetect.sh
# 
# Installation:
# Add this line to your .zshenv, .bashrc or .bash-profile:
#
# source /path/to/virtualenv-autodetect.sh

# https://github.com/egilewski/virtualenv-autodetect

_VIRTUALENV_ACTIVATION_SCRIPT_PATH="bin/activate"

_virtualenv_auto_activate() {
    _virtualenv_path=$(_get_virtualenv_path)
    if [ -e "$_virtualenv_path" ]
    then
        # Check if already activated to avoid redundant activation.
        if [ "$VIRTUAL_ENV" != $(readlink -f "$_virtualenv_path") ]
        then
            VIRTUAL_ENV_DISABLE_PROMPT=1
            source "$_virtualenv_path/$_VIRTUALENV_ACTIVATION_SCRIPT_PATH"
        fi
    else
        deactivate 2>/dev/null
    fi
}

# Get absolute path to virtualenv dir in current dir or one of it's parents.
_get_virtualenv_path() {
    # Find subdir of given one that is a virtualenv dir.
    _find_virtualenv_subdir() {
        for i in $(find $1 -maxdepth 1 -printf %f\\n)
        do
            if [ -e "$1/$i/$_VIRTUALENV_ACTIVATION_SCRIPT_PATH" ]
            then
                echo "$i"
                break
            fi
        done
    }

    _current_dir="$PWD"
    while true
    do
        _virtualenv_subdir=$(_find_virtualenv_subdir "$_current_dir")
        if [ "$_virtualenv_subdir" ]
        then
            echo "$_current_dir/$_virtualenv_subdir"
            return
        else
            if [[ "$_current_dir" != "/" ]]
            then
                _current_dir=`dirname "$_current_dir"`
            else
                return
            fi
        fi
    done
}

# Execute given function if derectory changed.
# Unlike in Zsh's "chpwd_functions" won't work with "cd .".
_bash_chpwd_function() {
    if [ "$PWD" != "$_myoldpwd" ]
    then
        _myoldpwd="$PWD";
        $1
    fi
}

# Before activation remove VIRTUAL_ENV from inherited env.
unset VIRTUAL_ENV

# Activate on shell start.
_virtualenv_auto_activate

# Activate on directory change.
# Zsh.
chpwd_functions=(_virtualenv_auto_activate)
# Bash.
export PROMPT_COMMAND="_bash_chpwd_function _virtualenv_auto_activate"
