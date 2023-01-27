;; doom-amarena-theme.el -*- no-byte-compile: t; -*-
(require 'doom-themes)

;; This is basically a copy-pasted doom theme
;; but instead of using hardcoded colors, it grabs them from Xresources.
;; Not tested on terminal emacs!
(defgroup doom-amarena-theme nil
  "Options for doom-themes"
  :group 'doom-themes)

(defcustom doom-amarena-brighter-modeline nil
  "If non-nil, more vivid colors will be used to style the mode-line."
  :group 'doom-amarena-theme
  :type 'boolean)

(defcustom doom-amarena-brighter-comments nil
  "If non-nil, comments will be highlighted in more vivid colors."
  :group 'doom-amarena-theme
  :type 'boolean)

(defcustom doom-amarena-comment-bg doom-amarena-brighter-comments
  "If non-nil, comments will have a subtle, darker background. Enhancing their
legibility."
  :group 'doom-amarena-theme
  :type 'boolean)

(defcustom doom-amarena-padded-modeline doom-themes-padded-modeline
  "If non-nil, adds a 4px padding to the mode-line. Can be an integer to
determine the exact padding."
  :group 'doom-amarena-theme
  :type '(choice integer boolean))

(defconst xrbg "#1A2026")
(defconst xrfg "#FFFFFF")
(defconst  xr0 "#242D35")
(defconst  xr1 "#FB6396")
(defconst  xr2 "#94CF95")
(defconst  xr3 "#F692B2")
(defconst  xr4 "#6EC1D6")
(defconst  xr5 "#CD84C8")
(defconst  xr6 "#7FE4D2")
(defconst  xr7 "#FFFFFF")
(defconst  xr8 "#526170")
(defconst  xr9 "#F92D72")
(defconst xr10 "#6CCB6E")
(defconst xr11 "#F26190")
(defconst xr12 "#4CB9D6")
(defconst xr13 "#C269BC")
(defconst xr14 "#58D6BF")
(defconst xr15 "#F4F5F2")

(defconst xrbase0 (doom-lighten xrbg 0.02))
(defconst xrbase1 (doom-lighten xrbg 0.04))
(defconst xrbase2 (doom-lighten xrbg 0.06))
(defconst xrbase3 (doom-lighten xrbg 0.08))
(defconst xrbase4 (doom-lighten xrbg 0.1))
(defconst xrbase5 (doom-lighten xrbg 0.12))
(defconst xrbase6 (doom-lighten xr8 0.1))
(defconst xrbase7 (doom-lighten xr8 0.2))
(defconst xrbase8 (doom-lighten xr8 0.3))

(def-doom-theme doom-amarena
  "A dark theme inspired by Atom One Dark"

  ;; name        default   256       16
  ((bg         `(,xrbg nil       nil            ))
   (bg-alt     `(,xr0 nil       nil            ))
   (base0      `(,xrbase0 "black"   "black"        ))
   (base1      `(,xrbase1 "brightblack"  ))
   (base2      `(,xrbase2 "brightblack"  ))
   (base3      `(,xr0 "brightblack"  ))
   (base4      `(,xrbase4 "brightblack"  ))
   (base5      `(,xr8 "#525252" "brightblack"  ))
   (base6      `(,xrbase6 "#6b6b6b" "brightblack"  ))
   (base7      `(,xrbase7 "#979797" "brightblack"  ))
   (base8      `(,xrbase8 "#dfdfdf" "white"        ))
   (fg         `(,xrfg "#bfbfbf" "brightwhite"  ))
   (fg-alt     `(,xr15 "#2d2d2d" "white"        ))

   (grey       `(,xr8))
   (red        `(,xr1 "#ff6655" "red"          ))
   (orange     `(,xr11 "#dd8844" "brightred"    ))
   (green      `(,xr2 "#99bb66" "green"        ))
   (teal       `(,xr10 "#44b9b1" "brightgreen"  ))
   (yellow     `(,xr3 "#ECBE7B" "yellow"       ))
   (blue       `(,xr4 "#51afef" "brightblue"   ))
   (dark-blue  `(,xr12 "#2257A0" "blue"         ))
   (magenta    `(,xr5 "#c678dd" "brightmagenta"))
   (violet     `(,xr13 "#a9a1e1" "magenta"      ))
   (cyan       `(,xr6 "#46D9FF" "brightcyan"   ))
   (dark-cyan  `(,xr14 "#5699AF" "cyan"         ))

   ;; face categories -- required for all themes
   (highlight      blue)
   (vertical-bar   (doom-darken base1 0.1))
   (selection      dark-blue)
   (builtin        magenta)
   (comments       (if doom-amarena-brighter-comments dark-cyan base5))
   (doc-comments   (doom-lighten (if doom-amarena-brighter-comments dark-cyan base5) 0.25))
   (constants      violet)
   (functions      magenta)
   (keywords       blue)
   (methods        cyan)
   (operators      blue)
   (type           yellow)
   (strings        green)
   (variables      (doom-lighten magenta 0.4))
   (numbers        orange)
   (region         `(,(doom-lighten (car bg-alt) 0.15) ,@(doom-lighten (cdr base1) 0.35)))
   (error          red)
   (warning        yellow)
   (success        green)
   (vc-modified    orange)
   (vc-added       green)
   (vc-deleted     red)

   ;; custom categories
   (hidden     `(,(car bg) "black" "black"))
   (-modeline-bright doom-amarena-brighter-modeline)
   (-modeline-pad
    (when doom-amarena-padded-modeline
      (if (integerp doom-amarena-padded-modeline) doom-amarena-padded-modeline 4)))

   (modeline-fg     fg)
   (modeline-fg-alt base5)

   (modeline-bg
    (if -modeline-bright
        (doom-darken blue 0.475)
      `(,(doom-darken (car bg-alt) 0.15) ,@(cdr base0))))
   (modeline-bg-l
    (if -modeline-bright
        (doom-darken blue 0.45)
      `(,(doom-darken (car bg-alt) 0.1) ,@(cdr base0))))
   (modeline-bg-inactive   `(,(doom-darken (car bg-alt) 0.1) ,@(cdr bg-alt)))
   (modeline-bg-inactive-l `(,(car bg-alt) ,@(cdr base1))))


  ;; --- extra faces ------------------------
  ((elscreen-tab-other-screen-face :background "#353a42" :foreground "#1e2022")

   (evil-goggles-default-face :inherit 'region :background (doom-blend region bg 0.5))

   ((line-number &override) :foreground base4)
   ((line-number-current-line &override) :foreground fg)

   (font-lock-comment-face
    :foreground comments
    :background (if doom-amarena-comment-bg (doom-lighten bg 0.05)))
   (font-lock-doc-face
    :inherit 'font-lock-comment-face
    :foreground doc-comments)

   (mode-line
    :background modeline-bg :foreground modeline-fg
    :box (if -modeline-pad `(:line-width ,-modeline-pad :color ,modeline-bg)))
   (mode-line-inactive
    :background modeline-bg-inactive :foreground modeline-fg-alt
    :box (if -modeline-pad `(:line-width ,-modeline-pad :color ,modeline-bg-inactive)))
   (mode-line-emphasis
    :foreground (if -modeline-bright base8 highlight))

   (solaire-mode-line-face
    :inherit 'mode-line
    :background modeline-bg-l
    :box (if -modeline-pad `(:line-width ,-modeline-pad :color ,modeline-bg-l)))
   (solaire-mode-line-inactive-face
    :inherit 'mode-line-inactive
    :background modeline-bg-inactive-l
    :box (if -modeline-pad `(:line-width ,-modeline-pad :color ,modeline-bg-inactive-l)))

   ;; Doom modeline
   (doom-modeline-bar :background (if -modeline-bright modeline-bg highlight))
   (doom-modeline-buffer-file :inherit 'mode-line-buffer-id :weight 'bold)
   (doom-modeline-buffer-path :inherit 'mode-line-emphasis :weight 'bold)
   (doom-modeline-buffer-project-root :foreground green :weight 'bold)

   ;; ivy-mode
   (ivy-current-match :background dark-blue :distant-foreground base0 :weight 'normal)

   ;; --- major-mode faces -------------------
   ;; css-mode / scss-mode
   (css-proprietary-property :foreground orange)
   (css-property             :foreground green)
   (css-selector             :foreground blue)

   ;; markdown-mode
   (markdown-markup-face :foreground base5)
   (markdown-header-face :inherit 'bold :foreground red)
   ((markdown-code-face &override) :background (doom-lighten base3 0.05))

   ;; org-mode
   (org-hide :foreground hidden)
   (org-level-1 :weight 'bold :family "sans" :height 1.75 :foreground xr6)
   (org-level-2 :weight 'bold :family "sans" :height 1.50 :foreground xr4)
   (org-level-3 :weight 'bold :family "sans" :height 1.25 :foreground xr5)
   (org-level-4 :weight 'bold :family "sans" :height 1.10 :foreground xr3)
   (org-level-5 :weight 'bold :family "sans" :foreground xr6)
   (org-level-6 :weight 'bold :family "sans" :foreground xr4)
   (org-level-7 :weight 'bold :family "sans" :foreground xr5)
   (org-level-8 :weight 'bold :family "sans" :foreground xr3)
   (solaire-org-hide-face :foreground hidden))


  ;; --- extra variables ---------------------
  ()
  )

;;; doom-amarena-theme.el ends here
