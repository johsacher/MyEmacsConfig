;; load this file in an init-file

;; * EXWM window manager (this might go into some EXWM.el later)
;; ** this is where the actual stuff is instructed (but defined in function, so that on other machines not loaded, or also when using other window manager)
(defun my-exwm-startup ()
  "this is invoked *when/once/if* exwm starts (just a list of instructions)"
  (require 'exwm)
  ;; not needed anymore (just for quick start beginners - load default configs, includes exwm-enable):
  ;; (require 'exwm-config) ;; not needed anymore
  ;; (exwm-config-default)  

  ;; ** monitor, resolution and stuff ("hard-core stuff.. ://")
  ;;    (todo: way not done yet.. but works alright)
  (require 'exwm-randr)
  (exwm-randr-enable)
  ;; for some reasons names eDP-1 changed to eDP1 / HDMI-1 -> HDMI1 / etc. don t know why, so had to "renew" this xrandr command
  ;; (start-process-shell-command "xrandr" nil "xrandr --output eDP-1 --primary --mode 1920x1080 --pos 320x1080 --rotate normal --output DP-1 --off --output HDMI-1 --off --output DP-2 --off --output HDMI-2 --mode 2560x1080 --pos 0x0 --rotate normal") ;; saved from arandr
  ;; (start-process-shell-command "xrandr" nil "xrandr --output eDP1 --primary --mode 1920x1080 --pos 0x0 --rotate normal --output DP1 --off --output DP2 --off --output HDMI1 --off --output HDMI2 --off --output VIRTUAL1 --off") ;; saved from arandr
  (setq exwm-randr-workspace-monitor-plist '(2 "HDMI2" 3 "HDMI2"))

  (setq exwm-workspace-number 5)

  ;; system crafters stuff
  (defun efs/run-in-background (command)
  (let ((command-parts (split-string command "[ ]+")))
    (apply #'call-process `(,(car command-parts) nil 0 nil ,@(cdr command-parts)))))

  (defun efs/exwm-update-class ()
    (exwm-workspace-rename-buffer exwm-class-name))
  (add-hook 'exwm-update-class-hook #'efs/exwm-update-class)


  (defun efs/set-wallpaper ()
  (interactive)
  ;; NOTE: You will need to update this to a valid background path!
  (start-process-shell-command
      "feh" nil  "feh --bg-scale /usr/share/backgrounds/xfce/Forrest.jpg"))
      ;; "feh" nil  "feh --bg-scale /usr/share/backgrounds/xfce/park.jpg"))

  ;; ** hooks on display change (undock/dock monitor)
  (defvar update-displays-executed nil);; just a debug variable (setq update-displays-executed nil)
  (defun efs/update-displays ()
    (setq update-displays-executed t) ;; just a debug variable
    ;; (efs/set-wallpaper)
    ;; * autorandr/randr stuff -> i think i don t need this, already automatically
    ;;T (efs/run-in-background "autorandr --change --force && ")
    ;; * tried this for cleaner solution but did not work
    ;; (efs/run-in-background
    ;;  (concat
    ;; "autorandr --change --force && "
    ;; "xinput --map-to-output 'Wacom Pen and multitouch sensor Pen stylus' eDP1 && "
    ;; "xinput --map-to-output 'Wacom Pen and multitouch sensor Pen eraser' eDP1 && "
    ;; "xinput --map-to-output 'Wacom Pen and multitouch sensor Finger touch' eDP1")) ;; kind of "brute force approach" autorandr does not always run automatically somehow, so better execute that every time a change is detected
	;; (message "Display config: %s"
	;;   (string-trim (shell-command-to-string "autorandr --current")))
    ;; * adjust touch/stylus areas
    ;;T (sleep-for 2) ;; really really dirty work around but alright.. it works!
    ;;T (js/adjust-stylus)
    )

  (defun js/adjust-stylus ()
    (interactive)
    (start-process-shell-command "xinput" nil "xinput --map-to-output 'Wacom Pen and multitouch sensor Pen eraser' eDP1 & xinput --map-to-output 'Wacom Pen and multitouch sensor Pen stylus' eDP1 & xinput --map-to-output 'Wacom Pen and multitouch sensor Finger touch' eDP1")) ;; works, but needs to be executed some time after autorandr

  ;;T (add-hook 'exwm-randr-screen-change-hook #'efs/update-displays)
  ;;T (add-hook 'exwm-randr-screen-change-hook #'js/adjust-stylus-when-monitor-docked)
  ;;T (efs/update-displays) ;; execute it directly on x-server startup

  ;; These keys should always pass through to Emacs
  (setq exwm-input-prefix-keys
    '(?\C-x
      ?\C-h
      ?\C-\ ;; Ctrl+Space
      ?\M-x))

  ;; Ctrl+Q will enable the next key to be sent directly
  (define-key exwm-mode-map [?\C-q] 'exwm-input-send-next-key)

  ;; Set up global key bindings.  These always work, no matter the input state!
  ;; Keep in mind that changing this list after EXWM initializes has no effect.
  (setq exwm-input-global-keys
        `(
          ;; Reset to line-mode (C-c C-k switches to char-mode via exwm-input-release-keyboard)
          ([?\s-r] . exwm-reset) ;; daviwil finds it usefull to "always get back'
	  
          ;; Move between windows
          ([?\M-h] . windmove-left)
          ([?\M-l] . windmove-right)
          ([?\M-k] . windmove-up)
          ([?\M-j] . windmove-down)

          ;; Launch applications via shell command
          ([?\s-&] . (lambda (command)
                       (interactive (list (read-shell-command "$ ")))
                       (start-process-shell-command command nil command)))
	  
          ;; Switch workspace
          ([?\s-w] . exwm-workspace-switch)
          ([?\s-`] . (lambda () (interactive) (exwm-workspace-switch-create 0))) ;; (recommendation by davi wil, use workspaces / quick change to workspace "0")
	  
          ;; 's-N': Switch to certain workspace with Super (Win) plus a number key (0 - 9)
          ,@(mapcar (lambda (i)
                      `(,(kbd (format "s-%d" i)) .
                        (lambda ()
                          (interactive)
                          (exwm-workspace-switch-create ,i))))
                    (number-sequence 0 9))))

  ;; ** last step = exwm-enable (whyever..)
  (defvar my-exwm-init-hook-launched t)
  (exwm-enable)
  )

;; ** auto start my exwm on startup
;; var 1 (did not work yet)
;; (add-hook 'exwm-init-hook #'(my-exwm-startup))

;; var2
(when (equal myhost "laptop")
  ;; TODO: start this only as hook on exwm-init or whatever don't know
  ;;       hmmm... how to detect which window manager was invoked?
  ;; hmm.. best way is to use exwm-init-hook -> TODO

  (setq window-manager (getenv "WINDOW_MANAGER")) ;; set in .xinitrc_exwm
  (if (equal window-manager "exwm")
      ;;T (my-exwm-startup)
  ))
