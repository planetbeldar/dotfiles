source "${ZPREZTODIR}/init.zsh"
source "${ZDOTDIR}/extra.zshrc"

if [[ $TERM != dumb ]]; then
  source $ZDOTDIR/aliases.zsh
fi

# no extended history (undo prezto default). does not matter when share_history is enabled (https://unix.stackexchange.com/a/399601)
# unsetopt EXTENDED_HISTORY

# To customize prompt, run `p10k configure` or edit ~/.config/zsh/.p10.zsh.
[[ ! -f ~/.config/zsh/.p10k.zsh ]] || source ~/.config/zsh/.p10k.zsh
