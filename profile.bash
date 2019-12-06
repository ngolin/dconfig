if [ -t 1 ]; then
    OLD_PROMPT_COMMAND="$PROMPT_COMMAND"
    # standard output is a tty
    # do interactive initialization
    if [ -r "$HOME/.config/sensible.bash" ]; then
        source "$HOME/.config/sensible.bash"
    fi
    # patch sensible.bash
    bind "set show-all-if-ambiguous off"
    PROMPT_COMMAND="$OLD_PROMPT_COMMAND"
    unset OLD_PROMPT_COMMAND
    CDPATH=".:~/Documents"
    HISTFILESIZE=10000
    HISTSIZE=5000
fi

# common
alias today='date +"%Y-%m-%d"'
if which youtube-dl >/dev/null; then
    alias youtube-dl="youtube-dl --all-subs"
fi
if ! which realpath >/dev/null && which python >/dev/null; then
    alias realpath='python -c "import os, sys; print(os.path.realpath(sys.argv[1]))"'
fi
if which git >/dev/null; then
    alias git-branch='git branch | while read line; do
        desc=$(git config branch.$(echo "$line" | sed "s/\* //g").description)
        echo -e "$line\t\t$desc"
    done'
fi

export EDITOR=vim

if [ $(uname) = Darwin ]; then
    alias ll='ls -alF'
    alias la='ls -A'
    alias l='ls -CF'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'

    # NOTE: /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
    export HOMEBREW_BOTTLE_DOMAIN=https://mirrors.ustc.edu.cn/homebrew-bottles
    export BASH_COMPLETION_COMPAT_DIR="$(brew --prefix)/etc/bash_completion.d"

    # NOTE: brew install bash-completion@2
    if [[ -r "$(brew --prefix)/etc/profile.d/bash_completion.sh" ]]; then
        source "$(brew --prefix)/etc/profile.d/bash_completion.sh"
    fi

    # if [ "$(pwd)" = "$HOME" ]; then
    #     FINDER=$(osascript -e 'tell application "Finder"' -e "${1-1} <= (count Finder windows)" -e "get POSIX path of (target of window ${1-1} as alias)" -e 'end tell' 2>/dev/null)
    #     if [ "$FINDER" = "" ]; then
    #         cd "$HOME/Documents"
    #     else
    #         cd "$FINDER"
    #     fi
    # fi

    if which wg-quick >/dev/null; then
        _wg0() {
            if ifconfig utun1 &>/dev/null; then
                export PS1="*$PS1"
                alias wg0='if wg-quick down wg0 &>/dev/null; then export PS1=${PS1:1}; _wg0; fi'
            else
                alias wg0='if wg-quick up wg0 &>/dev/null; then _wg0; fi'
            fi
        }
        _wg0
    fi
elif [ $(uname) = Linux ]; then
    if which wg-quick >/dev/null; then
        _wg0() {
            if ifconfig wg0 &>/dev/null; then
                export PS1="*$PS1"
                alias wg0='if wg-quick down wg0 &>/dev/null; then export PS1=${PS1:1}; _wg0; fi'
            else
                alias wg0='if wg-quick up wg0 &>/dev/null; then _wg0; fi'
            fi
        }
        _wg0
    fi
else
    echo '$(uname)' "'$(uname)' not in (Darwin, Linux)"
fi
