;; (setq default-frame-alist '((undecorated . t)))
;; (add-to-list 'default-frame-alist '(undecorated . t))
;; (add-to-list 'default-frame-alist '(drag-internal-border . 1))
;; (add-to-list 'default-frame-alist '(internal-border-width . 5))
;; (add-to-list 'default-frame-alist '(drag-with-header-line . 1))
(add-to-list 'auto-mode-alist '("^Dockerfile-.*$" . dockerfile-mode))
(add-to-list 'auto-mode-alist '("\\.mjml\\'" . web-mode))

(setq fancy-splash-image (concat doom-user-dir "images/ascii-apple-logo.svg"))

(setq user-full-name "Tony Höglund"
      user-mail-address "tony.hoglund@gmail.com")
(setq doom-font (font-spec :family "BlexMono Nerd Font" :weight 'book :size 14)
      doom-variable-pitch-font (font-spec :family "BlexMono Nerd Font" :weight 'normal :size 14)
      doom-font-increment 1
      doom-big-font-increment 4)
;; (setq doom-theme 'doom-rougez)
;; (setq doom-theme 'doom-opera)
(setq doom-theme 'doom-monokai-pro)
;; (setq doom-theme 'doom-wilmersdorf)
;; (setq doom-theme 'doom-ephemeral)
(setq confirm-kill-emacs nil)
(setq-default line-spacing 0.2)
;; Installed via Nix nerdfonts package (https://github.com/doomemacs/doomemacs/issues/7431#issuecomment-1722663411)
(setq nerd-icons-font-names '("SymbolsNerdFontMono-Regular.ttf"))

(setq eglot-connect-timeout 60
      eglot-send-changes-idle-time 0.1)

(setq display-line-numbers-type 'relative)

;; https://github.com/abo-abo/ace-window#aw-keys
;; change ace-window shortcuts to home row letters instead of numbers
(after! ace-window
  (setq aw-keys '(?a ?s ?d ?f ?g ?h ?j ?k ?l)))

;; projectile
(setq projectile-project-search-path
      '("~/Projects/swift/"
        "~/Projects/cpp"
        "~/Projects/py"
        "~/Projects/nix"
        "~/Projects/csharp"
        "~/Projects/js"
        "~/Projects/unifi"
        "~/Projects/rust"
        "~/Projects/kotlin"
        "~/Projects/haskell"
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
(setq writeroom-major-modes '(text-mode emacs-lisp-mode swift-mode python-mode sh-mode nix-mode cc-mode rustic-mode)
      writeroom-width 0.5               ;; default 80 (characters) https://github.com/joostkremers/writeroom-mode#width
      +zen-text-scale 0.1               ;; default 2
      +zen-window-divider-size 1        ;; default 4
      )

;; lsp-mode
(after! lsp-mode
  (progn
    (setq lsp-idle-delay 0.1
          lsp-csharp-server-path "/run/current-system/sw/bin/omnisharp"
          lsp-eslint-server-command '("vscode-eslint-language-server" "--stdio")
          lsp-log-max t
          )
  (add-to-list 'lsp-file-watch-ignored-directories "[/\\]build")
  ))
;; lsp-ui
(after! lsp-ui
  (setq lsp-ui-doc-enable t
        lsp-ui-sideline-show-hover nil
        lsp-ui-sideline-show-symbol nil
        lsp-enable-symbol-highlighting nil
        ;; lsp-ui-doc-max-width 90
        ;; lsp-ui-doc-max-height 10
        ))
;; flycheck (syntax, spelling etc)
(after! flycheck
  (setq flycheck-idle-change-delay 0.1
        ))

;; avy
(after! avy
  (setq avy-timeout-seconds 0.3))

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

(after! evil
  (evil-define-operator tt/evil-yank (beg end type register yank-handler)
    "Copy rectangle region to special register after evil-yank is performed."
    (interactive "<R><x><y>")
    ;; (message "%s %s %s %s" beg end type register)
    (evil-yank beg end type register yank-handler)
    (when (memq type '(line screen-line))
      (setq end (1- end)))
    (copy-rectangle-to-register rectangle-register beg end)))

(use-package! kbd-mode)
;; zmk/zephyr support
(use-package! kconfig-mode)
(use-package! dts-mode)

;; bindings
(load! "bindings.el")
