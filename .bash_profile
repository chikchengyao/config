echo 'setting up ~/.bash_profile'

# export PS1="\[\033[36m\]\u\[\033[m\]@\[\033[32m\]\h:\[\033[33;1m\]\w\[\033[m\]\$ "
export CLICOLOR=1
export LSCOLORS=GxFxCxDxBxegedabagaced
alias ls='ls -GFh'

# opam configuration
test -r /Users/chik/.opam/opam-init/init.sh && . /Users/chik/.opam/opam-init/init.sh > /dev/null 2> /dev/null || true
eval `opam config env`

# change to Documents, if opening a new shell into ~ because Who Does That
# otherwise remain at the same do
cd Documents > /dev/null # don't tell me that Documents doesn't exist

# common scripts shared with ~/.bashrc
source ~/.bash_common
