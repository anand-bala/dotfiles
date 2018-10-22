;; Emacs Configuration
;; Author: Anand Balakrishnan

;; PACKAGE INSTALLATION
;; --------------------------------------

(package-initialize)


(require 'package)
(add-to-list 'package-archives '("melpa" . "http://stable.melpa.org/packages/") t)
(add-to-list 'package-archives '("gnu" . "https://elpa.gnu.org/packages/") t)
(add-to-list 'package-archives '("org" . "https://orgmode.org/elpa/") t)

(package-initialize)
(when (not package-archive-contents) (package-refresh-contents))
(defconst my-installed-packages
  '(better-defaults
    material-theme
    flycheck
    helm
    rg
    company
    paradox))

(mapc #'(lambda (package)
	  (unless (package-installed-p package)
	    (package-install package)))
      my-installed-packages)

(require 'paradox)
(paradox-enable)

(when (memq window-system '(mac ns x))
  (exec-path-from-shell-initialize))

;; BASIC CUSTOMIZATION
;; --------------------------------------

(setq inhibit-startup-message t) ;; hide the startup message
(load-theme 'material t) ;; load material theme
(global-linum-mode t) ;; enable line numbers globally
(setq visible-bell nil)

(setq custom-file "~/.emacs.d/custom.el")
(load custom-file)

;; Org-Mode
;; --------
(require 'org)
(require 'ox-bibtex)
(setq org-latex-pdf-process '("latexmk -pdf -outdir=%o %f"))

(defun my-org-mode-truncate-lines ()
  ;; make the lines in the buffer wrap around the edges of the screen.
  (visual-line-mode)
  (org-indent-mode))

(defun my-org-mode-writemode-settings ()
  ;; Writemode options for Org mode
  (setq writeroom-width 0.8))

;; (add-hook 'org-mode-hook 'my-org-mode-truncate-lines)
;; (add-hook 'org-mode-hook 'my-org-writemode-settings)
(add-hook 'org-mode-hook 'org-indent-mode)
(add-hook 'org-mode-hook 'visual-line-mode)

