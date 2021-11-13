if command -v exa >/dev/null; then
  alias exa="exa --group-directories-first --git --ignore-glob='.DS_Store'";
  alias l="exa -1";
  alias ll="exa -lag";
  alias la="LC_COLLATE=C exa -la";
fi
