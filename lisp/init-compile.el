;;; init-compile.el --- Helpers for M-x compile -*- lexical-binding: t -*-
;;; Commentary:
;;; Code:

(setq-default compilation-scroll-output t)

(require-package 'alert)

;; Customize `alert-default-style' to get messages after compilation

(defun zenk/alert-after-compilation-finish (buf result)
  "Use `alert' to report compilation RESULT if BUF is hidden."
  (when (buffer-live-p buf)
    (unless (catch 'is-visible
              (walk-windows (lambda (w)
                              (when (eq (window-buffer w) buf)
                                (throw 'is-visible t))))
              nil)
      (alert (concat "Compilation " result)
             :buffer buf
             :category 'compilation))))

(after-load 'compile
  (add-hook 'compilation-finish-functions
            'zenk/alert-after-compilation-finish))

(defvar zenk/last-compilation-buffer nil
  "The last buffer in which compilation took place.")

(after-load 'compile
  (defun zenk/save-compilation-buffer (&rest _)
    "Save the compilation buffer to find it later."
    (setq zenk/last-compilation-buffer next-error-last-buffer))
  (advice-add 'compilation-start :after 'zenk/save-compilation-buffer)

  (defun zenk/find-prev-compilation (orig &optional edit-command)
    "Find the previous compilation buffer, if present, and recompile there."
    (if (and (null edit-command)
             (not (derived-mode-p 'compilation-mode))
             zenk/last-compilation-buffer
             (buffer-live-p (get-buffer zenk/last-compilation-buffer)))
        (with-current-buffer zenk/last-compilation-buffer
          (funcall orig edit-command))
      (funcall orig edit-command)))
  (advice-add 'recompile :around 'zenk/find-prev-compilation))

(global-set-key [f6] 'recompile)


(defun zenk/shell-command-in-view-mode (start end command &optional output-buffer replace &rest other-args)
  "Put \"*Shell Command Output*\" buffers into view-mode."
  (unless (or output-buffer replace)
    (with-current-buffer "*Shell Command Output*"
      (view-mode 1))))
(advice-add 'shell-command-on-region :after 'zenk/shell-command-in-view-mode)


(after-load 'compile
  (require 'ansi-color)
  (defun zenk/colourise-compilation-buffer ()
    (when (eq major-mode 'compilation-mode)
      (ansi-color-apply-on-region compilation-filter-start (point-max))))
  (add-hook 'compilation-filter-hook 'zenk/colourise-compilation-buffer))


(maybe-require-package 'cmd-to-echo)


(provide 'init-compile)
;;; init-compile.el ends here
