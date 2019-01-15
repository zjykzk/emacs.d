;;; init-go.el --- Golang support -*- lexical-binding: t -*-
;;; Commentary:
;;; Code:

(when (maybe-require-package 'go-mode)
  (require-package 'company-go)
  (require-package 'go-gopath)
  (require-package 'dumb-jump)
  (require-package 'go-guru)

  (after-load 'go-mode
    (setq-default tab-width 2)
    (setq-default column-number-mode nil)
    (setq tab-width 2)
    (setq gofmt-command "goimports")
    (add-hook 'before-save-hook #'gofmt-before-save)
    (add-hook 'go-mode-hook 'flycheck-mode)
    (add-hook 'go-mode-hook 'dumb-jump-mode)
    (add-hook 'go-mode-hook #'go-guru-hl-identifier-mode)
    (setq go-packages-function 'go-packages-go-list)
    (add-hook 'go-mode-hook 'company-mode))
  (after-load 'company-mode
    (add-to-list 'company-backends 'company-go))
  )


(provide 'init-go)
