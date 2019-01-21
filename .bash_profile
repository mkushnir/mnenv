#echo "Reading .bash_profile"
export ENV=$HOME/.bashrc
source $HOME/.profile


#if test -f "$HOME/.ssh-agent.env"
#then
#    . "$HOME/.ssh-agent.env"
#    if test -n "$SSH_AGENT_PID"
#    then
#        if ! ps -p $SSH_AGENT_PID >/dev/null 2>&1
#        then
#            echo Stale SSH Agent in $HOME/.ssh-agent.env
#        fi
#    fi
#fi
