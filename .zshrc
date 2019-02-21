export TERM=rxvt 
export PATH="/home/qch/bin:/home/qch/miniconda3/bin:$PATH" 
export TMPDIR=/home/qch/tmp 

powerline-daemon -q
. /usr/lib/python3.7/site-packages/powerline/bindings/zsh/powerline.zsh
ZSH_THEME="agnoster"
autoload -U compinit
compinit
_comp_options+=(globdots)
autoload -Uz up-line-or-beginning-search down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search

[[ -n "$key[Up]"   ]] && bindkey -- "$key[Up]"   up-line-or-beginning-search
[[ -n "$key[Down]" ]] && bindkey -- "$key[Down]" down-line-or-beginning-search

HISTFILE=$HOME/.zsh_history
HISTSIZE=1000
SAVEHIST=1000
setopt inc_append_history
setopt hist_ignore_all_dups
setopt hist_ignore_space
setopt hist_reduce_blanks
ssh-add -l > /dev/null || alias ssh='ssh-add -l >/dev/null || ssh-add && unalias ssh; ssh'
