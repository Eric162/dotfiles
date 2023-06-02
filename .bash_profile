# source global definitions
if [ -f $HOME/.profile ]; then . $HOME/.profile; fi
if [ -f $HOME/.bashrc ]; then . $HOME/.bashrc; fi

stty -ixon # don't freeze on ctrl+s

# Aliases

alias l='ls -GFah'
alias vi='vim'
alias gits="git s"
alias gut="git"

# tools
alias files-per-dir="du -a | cut -d/ -f2 | sort | uniq -c | sort -nr"

parse_git_branch() {
  git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/(\1)/'
}

export PS1='\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[1;30m\]\w\[\033[0;36m\] $(parse_git_branch)\[\033[00m\]$ '


export FZF_DEFAULT_COMMAND='rg --files --hidden --follow --no-ignore-vcs'
export VOLTA_HOME="$HOME/.volta"
export PATH="$VOLTA_HOME/bin:$PATH"
. "$HOME/.cargo/env"
