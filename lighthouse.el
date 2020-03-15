;;; lighthouse.el --- A wrapper for `lighthouse.rs`

;; Author: A. Eidukas <iwiivi@gmail.com>
;; Version: 0.1
;; Keywords: hue, home-automation, lights, philips
;; URL: https://github.com/finnkauski/emacs-lighthouse


;;; Commentary:
;;
;; This package is a Emacs wrapper for the Lighthouse command
;; line tool functionality. For more info on Lighthouse itself
;; see https://github.com/finnkauski/lighthouse
;;
;; NOTE: This is developed and tested on doom-emacs config
;; which is an amazing config by Hendrik Lissner
;; (see here: https://github.com/hlissner/doom-emacs)

;;; Code:

;; Basic commands wrapping the lighthouse binary
(defun lighthouse-call (command)
  "Call lighthouse with a given a COMMAND."
  (interactive "sCommand: ")
  (start-process-shell-command
   "lighthouse-call"
   nil
   (format "lh %s" command))
  )

(defun lighthouse-on ()
  "Turn on all lights."
  (interactive)
  (start-process-shell-command
   "lighthouse-on"
   nil
   "lh on"
   )
  )

(defun lighthouse-id-on (ids)
  "Turn on lights by IDS."
  (interactive "sIDs: ")
  (start-process-shell-command
   "lighthouse-id-on"
   nil
   (format "lh on -i %s" ids))
  )

(defun lighthouse-off ()
  "Turn off all lights."
  (interactive)
  (start-process-shell-command
   "lighthouse-off"
   nil
   "lh off"
   )
  )

(defun lighthouse-id-off (ids)
  "Turn off lights by IDS."
  (interactive "sIDs: ")
  (start-process-shell-command
   "lighthouse-id-off"
   nil
   (format "lh off -i %s" ids))
  )

(defun lighthouse-state (state)
  "Lighthouse send STATE string."
  (interactive "sState: ")
  (start-process-shell-command
   "lighthouse-state"
   nil
   (format "lh state %s" state))
  )

(defun lighthouse-id-state (state ids)
  "Lighthouse send STATE string to IDS."
  (interactive "sState: \nsIDs: ")
  (start-process-shell-command
   "lighthouse-id-state"
   nil
   (format "lh state %s -i %s" state ids))
  )

(defun lighthouse-bri (bri)
  "Lighthouse send BRI val as brightness."
  (interactive "nBrightness (0 - 254): ")
  (start-process-shell-command
   "lighthouse-bri"
   nil
   (format "lh bri %s" bri))
  )

(defun lighthouse-id-bri (bri ids)
  "Lighthouse send BRI val as brightness to IDS."
  (interactive "nBrightness (0 - 254): \nsIDs: ")
  (start-process-shell-command
   "lighthouse-id-bri"
   nil
   (format "lh bri %s -i %s" bri ids))
  )

(defun lighthouse-color (color)
  "Lighthouse send hexcode of COLOR."
  (interactive "sColor: ")
  (start-process-shell-command
   "lighthouse-color"
   nil
   (format "lh color %s" color))
  )

(defun lighthouse-id-color (color ids)
  "Lighthouse send hexcode of COLOR to IDS."
  (interactive "sColor: \nsIDs: ")
  (start-process-shell-command
   "lighthouse-id-color"
   nil
   (format "lh color %s -i %s" color ids))
  )

(defun lighthouse-loop ()
  "Put all lights in a colorloop."
  (interactive)
  (start-process-shell-command
   "lighthouse-loop"
   nil
   "lh loop"
   )
  )

(defun lighthouse-id-loop (ids)
  "Put lights into a colorloop by IDS."
  (interactive "sIDs: ")
  (start-process-shell-command
   "lighthouse-id-loop"
   nil
   (format "lh loop -i %s" ids))
  )

(defun lighthouse-info ()
  "Print out the state of the system in a popup buffer."
  (interactive)
  (call-process
   "lh"
   nil
   "*LIGHTHOUSE-INFO*"
   nil
   "info"
   )
  (display-buffer-pop-up-window (get-buffer "*LIGHTHOUSE-INFO*") '((window-height . 0.3)))  )

;; Minor mode for controlling lights
(define-minor-mode lighthouse-mode
  "Global mode allowing access to the lighthouse suite of commands"
  :lighter " lighthouse"
  :global t
  ;; Keymaps
  (defvar lighthouse-all-keymap (make-sparse-keymap))
  (map! :map lighthouse-all-keymap
        "s" #'lighthouse-state
        "o" #'lighthouse-on
        "x" #'lighthouse-off
        "b" #'lighthouse-bri
        "c" #'lighthouse-color
        "l" #'lighthouse-loop
        )

  (defvar lighthouse-id-keymap (make-sparse-keymap))
  (map! :map lighthouse-id-keymap
        "r" #'lighthouse-call
        "s" #'lighthouse-id-state
        "o" #'lighthouse-id-on
        "x" #'lighthouse-id-off
        "i" #'lighthouse-info
        "b" #'lighthouse-id-bri
        "c" #'lighthouse-id-color
        "l" #'lighthouse-id-loop
        "a" lighthouse-all-keymap
        )

  (map! :leader "l" lighthouse-id-keymap)
  )

;; Speed tracking mode
(defvar lighthouse-action-timer nil)
(defvar lighthouse-actions 0)

(defun lighthouse-action-reset ()
  "Get the number of actions taken and reset them."
  (lighthouse-state (format "{\\\"bri\\\":%d\\\,\\\"transition\\\":250}" (min (* lighthouse-actions 1.5) 254)))
  (setq lighthouse-actions 0)
  )

(defun lighthouse-increment-count ()
  "Increment action count action."
  (let ((command real-last-command))
    (when command
      (setq lighthouse-actions (+ lighthouse-actions 1))
      )
    ))

(define-minor-mode lightspeed-mode
  "Lighthouse mode that tracks the speed of your commands."
  :lighter " lighthouse-speed-mode"
  :global t
  (if lightspeed-mode
      (progn
        (add-hook 'pre-command-hook #'lighthouse-increment-count)
        (setq lighthouse-action-timer (run-with-timer 10 10 'lighthouse-action-reset))
        )

    (progn
      (remove-hook 'pre-command-hook #'lighthouse-increment-count)
      (setq lighthouse-action-timer nil)
      )))

;; Buffer tracking mode
(defvar lighthouse-alist
  '((org-mode . "ff00ff")
    (python-mode . "0000ff")
    (emacs-lisp-mode . "f47883")
    (rustic-mode . "ff0000")
    (web-mode . "ffd300")
    (css-mode . "ff0000")
    ))

(defun lighthouse-from-buffer ()
  "Lighthouse function to set the light color based on the current mode of the buffer."
  (when-let (color (cdr (assq major-mode lighthouse-alist)))
    (lighthouse-color color)))

(define-minor-mode lighthouse-tracking-mode
  "Lighthouse mode that follows what buffer you are in and changes the color."
  :lighter " lighthouse-tracking-mode"
  :global t
  (if lighthouse-tracking-mode
      (progn
        (add-hook 'doom-switch-buffer-hook #'lighthouse-from-buffer)
        (add-hook 'doom-switch-window-hook #'lighthouse-from-buffer)
        )
    (progn
      (remove-hook 'doom-switch-buffer-hook #'lighthouse-from-buffer))
    (remove-hook 'doom-switch-window-hook #'lighthouse-from-buffer)))

(provide 'lighthouse)

;;; lighthouse.el ends here
