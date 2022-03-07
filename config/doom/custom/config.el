(setq user-full-name "Tony Höglund"
      user-mail-address "tony.hoglund@gmail.com")
(setq doom-font (font-spec :family "SauceCodePro Nerd Font" :weight 'normal :size 14)
      doom-big-font-increment 1)
(setq doom-theme 'doom-rouge)
(setq confirm-kill-emacs nil)

;; (setq comp-speed 2)

;; disable ws-butler (causes lsp mirror buffer issues - https://github.com/hlissner/doom-emacs/issues/3267)
;; (remove-hook 'doom-first-buffer-hook #'ws-butler-global-mode)

;; https://github.com/abo-abo/ace-window#aw-keys
;; change ace-window shortcuts to home row letters instead of numbers
(after! ace-window
  (setq aw-keys '(?a ?s ?d ?f ?g ?h ?j ?k ?l)))


(setq projectile-project-search-path
  '("~/Projects/swift/"
    "~/Projects/cpp"
    "~/Projects/py"
    "~/Projects/nix"
    "~/Projects/csharp"
    ))
(after! projectile
  (projectile-discover-projects-in-search-path))


;; sourcekit-lsp debugging
;; (setq lsp-sourcekit-executable "$HOME/Projects/swift/sourcekit-lsp/.build/debug/sourcekit-lsp")


;; start dap-hydra after hitting a breakpoint
(after! dap-mode
  (add-hook 'dap-stopped-hook (lambda (arg) (call-interactively #'dap-hydra))))


;; treemacs
(after! treemacs
  (progn
    (treemacs-follow-mode t)
    (treemacs-fringe-indicator-mode 'always)
    (setq treemacs-file-event-delay 200
          +treemacs-git-mode 'deferred)
    ))


;; Zen/writeroom
(setq writeroom-major-modes '(text-mode emacs-lisp-mode swift-mode python-mode sh-mode nix-mode)
      writeroom-width 0.5       ;; default 80 (characters) https://github.com/joostkremers/writeroom-mode#width
      +zen-text-scale 0.1       ;; default 2
      )


;; lsp-mode
(after! lsp-mode
  (setq lsp-idle-delay 0.1
        lsp-csharp-server-path "/run/current-system/sw/bin/omnisharp"))
;; lsp-ui
(after! lsp-ui
  (setq lsp-ui-sideline-show-hover t
        lsp-ui-doc-enable t
        lsp-ui-doc-max-width 90
        lsp-ui-doc-max-height 10
        ))


;; avy
(after! avy
  (setq avy-timeout-seconds 0.3))


;; word-wrap
(+global-word-wrap-mode +1)
(dolist (mode nil) ;; disabled global modes (none)
  add-to-list '+word-wrap-disabled-modes mode)


;; find-file helpers
(defconst dotfiles-dir (or (getenv "DOTFILES") "~/.config/dotfiles"))
(defun find-file-in-dotfiles ()
  "Search for a file in `dotfiles-dir'."
  (interactive)
  (doom-project-find-file dotfiles-dir))


;; custom yank functions that uses picture mode
;; load package when the listed command(s) is used for the first time
(use-package! picture
  :commands picture-yank-rectangle-from-register)

(defconst rectangle-register ?R)

(defun tt/picture-yank-rectangle-from-register ()
  "Yank picture from special register, overwriting rectangle at point in buffer."
  (interactive)
  (picture-yank-rectangle-from-register rectangle-register))

(evil-define-operator tt/evil-yank (beg end type register yank-handler)
  "Copy rectangle region to special register after evil-yank is performed."
  (interactive "<R><x><y>")
  ;; (message "%s %s %s %s" beg end type register)
  (evil-yank beg end type register yank-handler)
  (when (memq type '(line screen-line))
    (setq end (1- end)))
  (copy-rectangle-to-register rectangle-register beg end))


;; bindings
(load! "bindings.el")
