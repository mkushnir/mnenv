#echo "Reading .bashrc ..."

if test -z "$BASH"
then
    return
fi
if test -f "$HOME/.shrc"
then
    source $HOME/.shrc
fi

# bash specific
export HISTCONTROL=erasedups:ignoredups:ignorespace
export HISTSIZE=2000

shopt -s histappend
if test -z "$VIM"
then
    case `id -u` in
        #0) PS1='\[\033[01;34m\]\h:\[\033[01;31m\]\A\[\033[00m\]:\[\033[01;34m\]\W\[\033[00m\]\$ ' ;;
        0) PS1='\[\033[01;34m\]\h:\[\033[01;33m\]\A\[\033[00m\]:\[\033[01;34m\]\W\[\033[00m\]\$ ' ;;
        #*) PS1='\[\033[01;34m\]\h:\[\033[01;36m\]\A\[\033[00m\]:\[\033[01;34m\]\W\[\033[00m\]\$ ' ;;
        *) PS1='\[\033[01;34m\]\h:\[\033[01;32m\]\A\[\033[00m\]:\[\033[01;34m\]\W\[\033[00m\]\$ ' ;;
    esac
else
    PS1='\[\033[01;38m\]\h:\[\033[01;38m\]\A\[\033[00m\]:\[\033[01;38m\]\W\[\033[00m\]\$ '
fi
