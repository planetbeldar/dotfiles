if command -v eza >/dev/null; then
  alias eza="eza --group-directories-first --icons --ignore-glob='.DS_Store'";
  alias l="eza -1";
  alias ll="eza -lag";
  alias la="LC_COLLATE=C eza -la";
fi

# alias diff="diff --color"
if command -v git >/dev/null; then
  alias gid="git diff --no-ext-diff --color-words --cached"
  alias gwd="git diff --no-ext-diff --color-words"
fi
