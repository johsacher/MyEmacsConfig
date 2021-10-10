;; load this file in an init-file

;; * seperate fun definitions from config
(defun efs/set-wallpaper ()
  (interactive)
  ;; NOTE: You will need to update this to a valid background path!
  (start-process-shell-command
      "feh" nil  "feh --bg-scale /usr/share/backgrounds/xfce/Forrest.jpg"))

(defun efs/update-displays ()
  ;; (efs/run-in-background "autorandr --change --force") ;; causing a lot of trouble! you re a bad bad boy!
  (sleep-for 2);; dirty workaround (wait for autorandr to finish)
  (efs/set-wallpaper)
  (js/adjust-stylus)
  )

(defun efs/run-in-background (command)
  (let ((command-parts (split-string command "[ ]+")))
    (apply #'call-process `(,(car command-parts) nil 0 nil ,@(cdr command-parts)))))

(defun js/adjust-stylus ()
    (interactive)
    (sleep-for 2) ;; dirty workaround (wait for autorandr to finish)
    (start-process-shell-command "xinput" nil "xinput --map-to-output 'Wacom Pen and multitouch sensor Pen eraser' eDP1 & xinput --map-to-output 'Wacom Pen and multitouch sensor Pen stylus' eDP1 & xinput --map-to-output 'Wacom Pen and multitouch sensor Finger touch' eDP1")) ;; works, but needs to be executed some time after autorandr

(defun efs/exwm-update-class ()
  (exwm-workspace-rename-buffer exwm-class-name))


;; * config
;; ALL THIS STUFF TO BE EXECUTED BEFORE (!) exwm-init
(efs/run-in-background "autorandr --change --force") ;; shell-command / call-process etc. did not work, only ef/run-in-background from david wilson (?)
(efs/update-displays)

(require 'exwm)
(setq exwm-input-prefix-keys
'(?\C-x
  ?\M-x
  ?\M-\ )) ;; evil leader access with Alt+Space

(setq exwm-input-global-keys
        `(
	  ([?\M-h] . windmove-left)
	  ;; * switch workspaces
          ([?\s-`] . (lambda () (interactive) (exwm-workspace-switch 0))) 
          ([?\s-0] . (lambda () (interactive) (exwm-workspace-switch 0))) 
	  ([?\s-1] . (lambda () (interactive) (exwm-workspace-switch 1))) 
	  ([?\s-2] . (lambda () (interactive) (exwm-workspace-switch 2))) 
	  ([?\s-3] . (lambda () (interactive) (exwm-workspace-switch 3)))
	  ([?\s-4] . (lambda () (interactive) (exwm-workspace-switch 4)))
	  ([?\s-5] . (lambda () (interactive) (exwm-workspace-switch 5)))
	  ;; * launch apps
          ([?\s-&] . (lambda (command)
                       (interactive (list (read-shell-command "$ ")))
                       (start-process-shell-command command nil command)))
	  ;; * window/config/movement -> "'M' is my leader"
          ;; move between windows
          ([?\M-h] . windmove-left)
          ([?\M-l] . windmove-right)
          ([?\M-k] . windmove-up)
          ([?\M-j] . windmove-down)
	  ;; split windwos
          ([?\M-2] . split-window-below)
          ([?\M-3] . split-window-right)
          ([?\M-0] . delete-window)
          ([?\M-1] . delete-other-windows) ;; aka "maximize"
	  ;; kill buffer (no prompt)
	  ([?\M-4] . kill-this-buffer-no-prompt)
	  ([?\M-d] . kill-this-buffer-no-prompt) ;; let s see which "kill-binding" will dominate, delete less used in future
	  ;; resize windows
          ([?\M-K] . enlarge-window-4)
          ([?\M-J] . shrink-window-4)
          ([?\M-H] . enlarge-window-horizontally-4)
          ([?\M-L] . shrink-window-horizontally-4)
	  ;; previous/next buffer
          ([?\M-y] . previous-buffer)
          ([?\M-o] . next-buffer)
	  ;; move the buffer
	  ([?\M-u] . get-this-buffer-to-move)
	  ([?\M-i] . switch-to-buffer-to-move)
	  ;; previous/next window-config
	  ([?\M-\[] 'winner-undo)
	  ([?\M-\]] 'winner-redo)

	  ;; switch buffer
	  ([?\M-b] . helm-mini) ;; change, when you change your favorite buffer switch command
	  ;; * reset (daviwil finds it usefull to "always get back')
          ([?\s-r] . exwm-reset))) 

(require 'exwm-randr)
;; (setq exwm-randr-workspace-monitor-plist ...)
;;   (add-hook 'exwm-randr-screen-change-hook
;;             (lambda ()
;;               (start-process-shell-command
;;                "xrandr" nil "xrandr --output VGA1 --left-of LVDS1 --auto")))
(exwm-randr-enable)

;; * monitors/workspaces
;; ** setup 4 workspaces
;; (setq exwm-workspace-number 4) ;;-> workspaces numbered: 0,1,2,3
;; (setq exwm-randr-workspace-monitor-plist '(0 "HDMI2" 1 "HDMI2")) ;; tech.comm.: maybe needs to be set after exwm-randr
;; ** setup minimal (2) workspaces
(setq exwm-workspace-number 6) ;;-> workspaces numbered: 0,1,...
;; (setq exwm-randr-workspace-monitor-plist '(1 "HDMI2")) 
(setq exwm-randr-workspace-monitor-plist '(0 "eDP1" 1 "eDP1" 2 "eDP1" 3"HDMI2" 4 "HDMI2" 5 "HDMI2" )) 

;; (add-hook 'exwm-randr-screen-change-hook #'efs/update-displays) ;; causes trouble
(add-hook 'exwm-randr-screen-change-hook #'efs/update-displays) ;; causes trouble (js/adjust-stylus)

(add-hook 'exwm-update-class-hook #'efs/exwm-update-class)

(exwm-enable)


;; (setq mouse-autoselect-window t)
;; (setq focus-follows-mouse t)
(setq mouse-autoselect-window nil)
(setq focus-follows-mouse nil)
(setq exwm-workspace-show-all-buffers t)
(setq exwm-layout-show-all-buffers t)


;; EXWM-ENABLE to be executed as LAST command AND BEFORE EXWM-INIT


(defun js/screenshot-mouse-select-to-clipboard ()
  (interactive)
  ;; (async-shell-command "scrot 'screenshot_%Y-%m-%d_%H-%M-%S.png' -s -e 'xclip -selection clipboard -t image/png -i $f    &&  mv $f ~/.screenshots/'"))
;;  (hangs / error, even though in terminal it works... :(
  ;; -> workaround:
  (setq command-string (concat "scrot 'screenshot_%Y-%m-%d_%H-%M-%S.png' -s -e 'xclip -selection clipboard -t image/png -i $f    &&  mv $f ~/.screenshots/'" "\n")) ;; "\n" = execute
  (comint-send-string  draft-horse-term-buffer-name command-string))
(global-set-key (kbd "M-<print>") 'js/screenshot-mouse-select-to-clipboard)
      

;; * enable "normal" CTRL-c for copy in applications (exwm-buffers)
(define-key exwm-mode-map (kbd "C-c") nil)
;; (mind: this disables the typical EXWM bindings (so rebind those if you wanna use theme):
;; C-c C-f 	exwm-layout-set-fullscreen 	Enter fullscreen mode
;; C-c C-h 	exwm-floating-hide 	Hide a floating X window
;; C-c C-k 	exwm-input-release-keyboard 	Switch to char-mode
;; C-c C-m 	exwm-workspace-move-window 	Move X window to another workspace
;; C-c C-q 	exwm-input-send-next-key 	Send a single key to the X window;
;; can be prefixed with C-u to send multiple keys
;; C-c C-t C-f 	exwm-floating-toggle-floating 	Toggle between tiling and floating mode
;; C-c C-t C-m 	exwm-layout-toggle-mode-line 	Toggle mode-line

(setq framemove-hook-into-windmove nil)
