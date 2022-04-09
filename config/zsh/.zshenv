source "${ZDOTDIR}/extra.zshenv"

# Don't load /etc/zprofile and /etc/zshrc (https://zsh.sourceforge.io/Doc/Release/Files.html#Files)
setopt no_global_rcs

# Use Zsh's own implmentation, must disable for macOS
SHELL_SESSIONS_DISABLE=1
