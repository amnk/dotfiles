#zmodload zsh/zprof

# ZSH configuration
# https://github.com/sorin-ionescu/prezto/blob/e149367445d2bcb9faa6ada365dfd56efec39de8/modules/completion/init.zsh#L34
autoload -Uz compinit
_comp_files=(${ZDOTDIR:-$HOME}/.zcompdump(Nm-20))
if (( $#_comp_files )); then
  compinit -i -C
else
  compinit -i
fi

# taken from https://github.com/robbyrussell/oh-my-zsh/blob/master/lib/history.zsh
## History file configuration
[ -z "$HISTFILE" ] && HISTFILE="$HOME/.zsh_history"
HISTSIZE=50000
SAVEHIST=10000

## History command configuration
setopt extended_history       # record timestamp of command in HISTFILE
setopt hist_expire_dups_first # delete duplicates first when HISTFILE size exceeds HISTSIZE
setopt hist_ignore_dups       # ignore duplicated commands history list
setopt hist_ignore_space      # ignore commands that start with space
setopt hist_verify            # show command with history expansion to user before running it
setopt inc_append_history     # add commands to HISTFILE in order of execution
setopt share_history          # share command history data

#############################################################################
## Key bindings
# taken from https://github.com/robbyrussell/oh-my-zsh/blob/master/lib/key-bindings.zsh
bindkey -e                                            # Use emacs key bindings

bindkey '\ew' kill-region                             # [Esc-w] - Kill from the cursor to the mark
bindkey '^r' history-incremental-search-backward      # [Ctrl-r] - Search backward incrementally for a specified string. The string may begin with ^ to anchor the search to the beginning of the line.

# Better search with up/down keys
autoload -U up-line-or-beginning-search
autoload -U down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search
bindkey "^[[A" up-line-or-beginning-search # Up
bindkey "^[[B" down-line-or-beginning-search # Down

bindkey ' ' magic-space                               # [Space] - do history expansion

bindkey '^[[1;5C' forward-word                        # [Ctrl-RightArrow] - move forward one word
bindkey '^[[1;5D' backward-word                       # [Ctrl-LeftArrow] - move backward one word

bindkey '^?' backward-delete-char                     # [Backspace] - delete backward
if [[ "${terminfo[kdch1]}" != "" ]]; then
  bindkey "${terminfo[kdch1]}" delete-char            # [Delete] - delete forward
else
  bindkey "^[[3~" delete-char
  bindkey "^[3;5~" delete-char
  bindkey "\e[3~" delete-char
fi

# file rename magick
bindkey "^[m" copy-prev-shell-word

#############################################################################
# Load additional files
#
# Aliases
source $HOME/.aliases

# ASDF
. $HOME/.asdf/asdf.sh
#############################################################################


#############################################################################
# Settings related to blox theme and plugins that change prompt
# aws setup
AWS_CONFIG_FILE="$HOME/.aws/credentials"
#############################################################################
export LANG=en_US.UTF-8
export SSH_KEY_PATH="~/.ssh/rsa_id"
export EDITOR="nvim"
export PATH=$HOME/bin:$HOME/go/bin:/usr/local/bin:$HOME/.cargo/bin:$PATH
export PATH="${KREW_ROOT:-$HOME/.krew}/bin:$PATH"
export FZF_DEFAULT_COMMAND='fd --type file --follow --hidden --exclude .git'
#############################################################################
eval "$(pyenv init -)"
eval "$(pyenv virtualenv-init -)"
export PATH="/usr/local/opt/mysql-client/bin:$PATH"

eval "$(starship init zsh)"
