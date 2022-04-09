source "${ZPREZTODIR}/init.zsh"
source "${ZDOTDIR}/extra.zshrc"

if [[ $TERM != dumb ]]; then
  source $ZDOTDIR/aliases.zsh
fi

# prezto makes me set these things later than I should have to
HISTSIZE=120000;
SAVEHIST=100000;

# To customize prompt, run `p10k configure` or edit ~/.config/zsh/.p10.zsh.
[[ ! -f ~/.config/zsh/.p10k.zsh ]] || source ~/.config/zsh/.p10k.zsh
