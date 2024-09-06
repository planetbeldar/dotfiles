;; Custom key bindings

;;
;;; <leader>
(map! :leader

      (:when (modulep! :tools debugger)
        ;;; <leader> d --- debug (dap-mode)
        (:prefix-map ("d" . "debug")
          :desc "Start new"                     "s" #'dap-debug
          :desc "Start last"                    "d" #'dap-debug-last
          :desc "Start recent"                  "r" #'dap-debug-recent
          :desc "Edit template"                 "e" #'dap-debug-edit-template
          :desc "Edit prepopulated template"    "E" (cmd!! #'dap-debug-edit-template t)
          :desc "Toggle hydra"                  "t" #'dap-hydra
          :desc "Output"                        "o" #'dap-go-to-output-buffer
          ))

      ;;; <leader> o --- open
      (:prefix ("o")
        :desc "Start DAP debugger"              "d" #'dap-debug-last
        )

      ;;; <leader> t --- toggle
      (:prefix ("t")
        :desc "DAP hydra"                       "D" #'dap-hydra
        ;; must add modes to writeroom-major-modes
        :desc "Zen mode (global)"               "Z" #'global-writeroom-mode
        ;; :desc "Centered window mode"            "c" #'centered-window-mode
        )

      ;;; <leader> w --- window
      (:prefix ("w")
                                                "w"   #'ace-window
                                                "C-w" #'evil-window-next
                                                )
      ;;; <leader> f --- file
      (:prefix ("f")
        :desc "Find file in dotfiles"           "." #'find-file-in-dotfiles
        )
      )

(map! :after cc-mode
      :map c-mode-map
                                                "TAB" nil
                                                "<tab>" nil)
(map! :after treemacs-evil
      :map evil-treemacs-state-map
      :desc "open mru window"                   ";" #'treemacs-visit-node-in-most-recently-used-window)

(map! :after evil
      :n                                        "z r" #'evil-replace-with-register ;;default "g r" already taken
      :nv                                       "z p" #'tt/picture-yank-rectangle-from-register
      :nvo                                      "y"   #'tt/evil-yank
      )
