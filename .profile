# $FreeBSD: src/share/skel/dot.profile,v 1.21 2002/07/07 00:00:54 mp Exp $
#
# .profile - Bourne Shell startup script for login shells
#
# see also sh(1), environ(7).
#

# remove /usr/games and /usr/X11R6/bin if you want
#echo "Reading .profile ..."
PATH=$HOME/bin:/sbin:/bin:/usr/sbin:/usr/bin:/usr/games:/usr/local/sbin:/usr/local/bin:/root/bin:$HOME/share; export PATH

#MM_CHARSET=KOI8-U; export MM_CHARSET
#LANG=uk_UA.KOI8-U; export LANG
#LC_CTYPE=uk_UA.KOI8-U; export LC_CTYPE
#LC_ALL=uk_UA.KOI8-U; export LC_ALL

MM_CHARSET=UTF-8; export MM_CHARSET
LANG=uk_UA.UTF-8; export LANG
LC_CTYPE=uk_UA.UTF-8; export LC_CTYPE
LC_ALL=uk_UA.UTF-8; export LC_ALL

BLOCKSIZE=K;	export BLOCKSIZE
EDITOR=vim;   	export EDITOR
PAGER="less -R";  	export PAGER

# X 0 mode
#   3 fore color
#   4 back color
#
# Y 0 default
#   1 +brightness
#   2 -brightness
#   4 underscore
#   5 blink
#   7 invert
#   8 hide
#
# Y 0 black
#   1 red
#   2 green
#   3 yellow
#   4 blue
#   5 purple
#   6 cyan
#   7 white
#
# begin blinking
export LESS_TERMCAP_mb=`printf "\033[01;33m"`

# begin bold
#export LESS_TERMCAP_md=`printf "\033[01;32m"`
export LESS_TERMCAP_md=`printf "\033[01;34m"`
#export LESS_TERMCAP_md=`printf "\033[01;44;32m"`

# end
export LESS_TERMCAP_me=`printf "\033[0m"`

# begin standout, info block, selection
export LESS_TERMCAP_so=`printf "\033[01;30;42m"`

# end standout
export LESS_TERMCAP_se=`printf "\033[0m"`

# begin underscore
#export LESS_TERMCAP_us=`printf "\033[01;33m"`
export LESS_TERMCAP_us=`printf "\033[04;36m"`

# end underscore
export LESS_TERMCAP_ue=`printf "\033[0m"`

# ???
#export LESS_TERMCAP_mr=`printf "\033[05;31m"`
#export LESS_TERMCAP_mh=`printf "\033[05;31m"`
#export LESS_TERMCAP_ZN=`printf "\033[05;31m"`
#export LESS_TERMCAP_ZV=`printf "\033[05;31m"`
#export LESS_TERMCAP_ZO=`printf "\033[05;31m"`
#export LESS_TERMCAP_ZW=`printf "\033[05;31m"`

export GREP_COLOR="1;31"
export COLORTERM=1
export LSCOLORS=gxfxcxdxbxegedabagacad

#export TMPDIR=$HOME/tmp

cd() {
    if test -z "$1"
    then
        builtin cd "$HOME" && printf "\033]0;$HOSTNAME:$PWD\007"
    else
        builtin cd "$@" && printf "\033]0;$HOSTNAME:$PWD\007"
    fi
}

#export REPLYTO=${USER}@llnw.com
export REPLYTO=markiyan.kushnir@gmail.com
#export LD_LIBRARY_PATH=/usr/local/openoffice.org-3.1.1/openoffice.org/ure/lib/
#export LD_LIBRARY_PATH=$HOME/lib
#unset LD_LIBRARY_PATH
#export LDFLAGS=-L$HOME/lib
#unset LDFLAGS
#export CFLAGS=-I$HOME/include
#unset CFLAGS
#export PKG_DBDIR=$HOME/pkg
#export LUA_PATH=$HOME/work/lua51


#export SQUID_ROOT=$HOME/work/llnw/squid
#export SQUID_PORT_PREFIX=45

#export CVSROOT=:ext:$USER@dev1.qa.llnw.net:/home/cvs
#export CVSROOT=:pserver:anoncvs@anoncvs.freebsd.org:/home/ncvs
#export CVSROOT=:ext:anoncvs@anoncvs.freebsd.org:/home/ncvs
#export CVSROOT=:ext:$USER@gambit.llnw.com:/home/cvs
#export CVS_RSH=/home/mkushnir/bin/ssh-dev1

#export GIT_SSH=$HOME/bin/gitssh-eq
#export EQ_DEV_HGKEY=$HOME/.ssh/id_rsa-hg-rdonly
#export EQ_DEV_PYTHONVER=2.7.6
#export EQ_DEV__PYTHONVER=27

#export BIBI_DEV_APPROOT=/data2/mkushnir/development/bibi/qwe

if test -z "$ENV"
then
    ENV=$HOME/.shrc; export ENV
fi
test -f "$ENV" && . $ENV

