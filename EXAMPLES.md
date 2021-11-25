

## .bash_profile

```bash
# Get the aliases and functions
if [ -f ~/.bashrc ]; then
  . ~/.bashrc
fi

# User specific environment and startup programs
function say() {
  # echo "saying $1..."
  ssh eshirley@eshirley-mn3 "say \"$1\""
}

# auto-initialize some kind of session-based program
vncserver -list | grep -q "^:1\s\+" || vncserver -geometry 2560x1440
```


## .bashrc

```bash
# not sure why this is here but yeah
[ -f ~/.fzf.bash ] && source ~/.fzf.bash
```
