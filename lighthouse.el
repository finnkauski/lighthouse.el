;;; lighthouse.el --- A wrapper for `lighthouse.rs`

;; Copyright (C) 2011 Free Software Foundation, Inc.

;; Author: A. Eidukas <iwiivi@gmail.com>
;; Version: 0.1
;; Keywords: hue, home-automation, lights, philips
;; URL: https://github.com/finnkauski/emacs-lighthouse


;;; Commentary:

;; This package is a Emacs wrapper for the Lighthouse command
;; line tool functionality. For more info on Lighthouse itself
;; see https://github.com/finnkauski/lighthouse

;;; Code:

(defun lighthouse-call (command)
  "Call lighthouse with a given set of commands.

Passes whatever string is passed in to 'lh' under
the hood.

The COMMAND is a string command collected from the user interactively.
"
  (interactive "sCommand: ")
  (start-process-shell-command
   "lighthouse-call"
   nil
   (format "lh %s" command))
  )

(defun lighthouse-on ()
  "Turn on all lights"
  (interactive)
  (start-process-shell-command
   "lighthouse-on"
   nil
   "lh on"
   )
  )

(defun lighthouse-off ()
  "Turn off all lights"
  (interactive)
  (start-process-shell-command
   "lighthouse-off"
   nil
   "lh off"
   )
  )

(defun lighthouse-state (state)
  "Lighthouse send state string"
  (interactive "sState: ")
  (start-process-shell-command
   "lighthouse-state"
   nil
   (format "lh state %s" state))
  )

(defun lighthouse-bri (bri)
  "Lighthouse send state string"
  (interactive "nBrightness (0 - 254): ")
  (start-process-shell-command
   "lighthouse-bri"
   nil
   (format "lh bri %s" bri))
  )

(defun lighthouse-info ()
  "Print out the state of the system in a popup buffer"
  (interactive)
  (call-process
   "lh"
   nil
   "*LIGHTHOUSE-INFO*"
   nil
   "info"
   )
  (display-buffer-pop-up-window (get-buffer "*LIGHTHOUSE-INFO*") '((window-height . 0.3)))  )


(defvar lighthouse-keymap (make-sparse-keymap))
(map! :map lighthouse-keymap
      "h r" #'lighthouse-call
      "h s" #'lighthouse-state
      "h o" #'lighthouse-on
      "h x" #'lighthouse-off
      "h i" #'lighthouse-info
      "h b" #'lighthouse-bri
      )
(map! :leader "l" lighthouse-keymap)
