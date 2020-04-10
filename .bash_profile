# source global definitions
if [ -f $HOME/.profile ]; then . $HOME/.profile; fi
if [ -f $HOME/.bashrc ]; then . $HOME/.bashrc; fi

stty -ixon # don't freeze on ctrl+s
alias l='ls -GFah'
alias vi='vim'

parse_git_branch() {
  git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/(\1)/'
}

export PS1='\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[1;30m\]\w\[\033[0;36m\] $(parse_git_branch)\[\033[00m\]$ '

export VOLTA_HOME="/home/eshirley/.volta"
grep --silent "$VOLTA_HOME/bin" <<< $PATH || export PATH="$VOLTA_HOME/bin:$PATH"
