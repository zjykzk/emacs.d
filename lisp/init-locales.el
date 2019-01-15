
;;; init-locales.el --- Configure default locale -*- lexical-binding: t -*-
;;; Commentary:
;;; Code:

(defun zenk/utf8-locale-p (v)
  "Return whether locale string V relates to a UTF-8 locale."
  (and v (string-match "UTF-8" v)))

(defun zenk/locale-is-utf8-p ()
  "Return t iff the \"locale\" command or environment variables prefer UTF-8."
  (or (zenk/utf8-locale-p (and (executable-find "locale") (shell-command-to-string "locale")))
      (zenk/utf8-locale-p (getenv "LC_ALL"))
      (zenk/utf8-locale-p (getenv "LC_CTYPE"))
      (zenk/utf8-locale-p (getenv "LANG"))))

(when (or window-system (zenk/locale-is-utf8-p))
  (set-language-environment 'utf-8)
  (setq locale-coding-system 'utf-8)
  (set-default-coding-systems 'utf-8)
  (set-terminal-coding-system 'utf-8)
  (set-selection-coding-system (if (eq system-type 'windows-nt) 'utf-16-le 'utf-8))
  (prefer-coding-system 'utf-8))

(provide 'init-locales)
;;; init-locales.el ends here
