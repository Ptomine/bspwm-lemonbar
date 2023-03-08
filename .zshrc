export TERM=rxvt
powerline-daemon -q
. /usr/lib/python3.10/site-packages/powerline/bindings/zsh/powerline.zsh
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

alias grep="grep --color"
bindkey "^[[3~" delete-char
bindkey '^[Oc' forward-word
bindkey '^[Od' backward-word

alias gst="git status"
alias gall="git add --all"
gcm() { git commit -m "`git branch | grep \* | cut -d ' ' -f2`: `[ -z \"$1\" ] && date '+%Y-%m-%d %H:%M' || echo \"$1\"`" }
#alias gcm="git commit -m \"\`git branch | grep \* | cut -d ' ' -f2\`: \`date '+%Y-%m-%d %H:%M'\`\""
alias gpc="git push origin \`git branch | grep \* | cut -d ' ' -f2\`"
gfp() { gall && gcm "$1" && gpc }
gnb() { git fetch && git checkout master && git pull && git checkout -b "$1" }
alias brokenlinks="find . -type l ! -exec test -e {} \; -print"
alias okvpn="sudo openconnect enter.odkl.ru -c ~/certs/ok-ca.crt -k ~/certs/key.pem --authgroup OK_OutOfOffice"
alias initkb="setxkbmap -layout us,ru -variant -option grp:alt_shift_toggle, terminate:ctrl_alt_bksp &"

#PATH="/home/a_chakvetadze/perl5/bin${PATH:+:${PATH}}"; export PATH;
#PERL5LIB="/home/a_chakvetadze/perl5/lib/perl5${PERL5LIB:+:${PERL5LIB}}"; export PERL5LIB;
#PERL_LOCAL_LIB_ROOT="/home/a_chakvetadze/perl5${PERL_LOCAL_LIB_ROOT:+:${PERL_LOCAL_LIB_ROOT}}"; export PERL_LOCAL_LIB_ROOT;
#PERL_MB_OPT="--install_base \"/home/a_chakvetadze/perl5\""; export PERL_MB_OPT;
#PERL_MM_OPT="INSTALL_BASE=/home/a_chakvetadze/perl5"; export PERL_MM_OPT;

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/home/a_chakvetadze/miniconda3/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/home/a_chakvetadze/miniconda3/etc/profile.d/conda.sh" ]; then
        . "/home/a_chakvetadze/miniconda3/etc/profile.d/conda.sh"
    else
        export PATH="/home/a_chakvetadze/miniconda3/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<

