alias l='ls -GFah'

parse_git_branch() {
  git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/(\1)/'
}

export PS1='\u@\h \[\033[1;30m\]\w\[\033[0;36m\] $(parse_git_branch)\[\033[00m\]]$ '
