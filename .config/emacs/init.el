(defvar bootstrap-version)
(let ((bootstrap-file
       (expand-file-name "straight/repos/straight.el/bootstrap.el" user-emacs-directory))
      (bootstrap-version 5))
  (unless (file-exists-p bootstrap-file)
    (with-current-buffer
	(url-retrieve-synchronously
	 "https://raw.githubusercontent.com/raxod502/straight.el/develop/install.el"
	 'silent 'inhibit-cookies)
      (goto-char (point-max))
      (eval-print-last-sexp)))
  (load bootstrap-file nil 'nomessage))

(straight-use-package 'use-package)
(setq straight-use-package-by-default t)

(setq custom-file (expand-file-name "custom.el" user-emacs-directory))
(when (file-exists-p custom-file)
  (load custom-file))

(use-package which-key
  :config
  (which-key-mode))

;; Hide splash page
(setq inhibit-startup-message t)

;; Put as many prompts in minibuffer as possible
(setq use-dialog-box nil)

;; Show column number in modeline
(column-number-mode t)

;; Highlight the line the cursor is on
(global-hl-line-mode t)

;; Show time in modeline
(display-time-mode t)

;; Change cursor to vertical line
(setq-default cursor-type 'bar)

;; Set margins on all sides
(push '(internal-border-width . 16) default-frame-alist)

(use-package srcery-theme
  :config
  (load-theme 'srcery t))

(use-package all-the-icons)

(use-package emojify
  :hook (after-init . global-emojify-mode))

(use-package rainbow-mode)

(use-package doom-modeline
  :init (doom-modeline-mode 1)
  :custom
  (doom-modeline-icon t)
  (doom-modeline-height 35))

(use-package dashboard
  :config
  (dashboard-setup-startup-hook)
  :custom
  (initial-buffer-choice
   (lambda ()
     (get-buffer "*dashboard*"))))

;; Sane scrolling
(setq scroll-conservatively 101)

;; Auto save all buffers when frame loses focus
(add-hook 'focus-out-hook (lambda () (save-some-buffers t)))

;; Centralize backup files
(setq backup-directory-alist `(("." . ,(expand-file-name "backup" user-emacs-directory)))
      version-control t
      kept-new-version 10
      kept-old-versions 6)

;; Store autosave files in temp dir instead
(setq auto-save-file-name-transforms
      `((".*" ,temporary-file-directory t)))

;; Delete old backup files automatically
(setq delete-old-versions t)

;; Highlight matching parens
(setq show-paren-delay 0
      show-paren-when-point-inside-paren t)
(show-paren-mode t)

;; Replaces selcted text rather than ignoring it and inserting on cursor
(delete-selection-mode t)

;; Hide the cursor in inactive windows
(setq cursor-in-non-selected-windows t)

;; Replace yes/no prompts with y/n
(fset 'yes-or-no-p 'y-or-n-p)

;; Use ibuffer
(defalias 'list-buffers 'ibuffer)

;; Async Shell commands
(setq-default async-shell-command-display-buffer nil
	      async-shell-command-buffer 'new-buffer)

(use-package ace-window
  :custom
  (aw-scope 'frame)
  :bind
  ("M-o" . ace-window)
  ([remap other-window] . ace-window))

(use-package selectrum
  :config (selectrum-mode))

(use-package marginalia
  :bind (:map minibuffer-local-map
	      ("M-A" . marginalia-cycle))
  :init (marginalia-mode)
  :custom (marginalia-annotators
	   '(marginalia-annotators-heavy marginalia-annotators-light nil)))

(use-package orderless
  :custom (completion-styles '(orderless)))

(use-package visual-fill-column)

(use-package telega
  :after visual-fill-column
  :commands (telega)
  :config
  (telega-notifications-mode 1)
  (add-hook 'telega-chat-mode-hook
	    (lambda ()
	      (set (make-local-variable 'comapny-backends)
		   (append '(telega-company-emoji
			     telega-company-username
			     telega-company-hashtag)
			   (when (telega-chat-bot-p telega-chatbuf--chat)
			     '(telega-company-botcmd))))
	      (company-mode 1))))

(use-package rustic
  :bind (:map rustic-mode-map
	      ("M-?" . lsp-find-references)
	      ("M-." . lsp-find-definition)
	      ("C-c C-c l" . flycheck-list-errors)
	      ("C-c C-c a" . lsp-execute-code-action)
	      ("C-c C-c r" . lsp-rename)
	      ("C-c C-c q" . lsp-workspace-restart)
	      ("C-c C-c Q" . lsp-workspace-shutdown)
	      ("C-c C-c s" . lsp-rust-analyzer-status))
  :config
  (setq rustic-format-on-save t))

(use-package lsp-mode
  :commands (lsp lsp-deferred)
  :config
  (setq lsp-keymap-prefix "C-c l")
  (lsp-enable-which-key-integration t)
  :hook
  (python-mode . lsp-deferred))

(use-package lsp-ui
  :after lsp-mode
  :commands lsp-ui-mode
  :custom
  (lsp-ui-peek-always-show t)
  (lsp-ui-sideline-show-hover t)
  (lsp-ui-doc-position 'at-point)
  (lsp-eldoc-render-all t)
  :hook
  (lsp-mode . lsp-ui-mode))

(use-package realgud
  :commands
  (realgud:pdb))

;; Beautify Org Src blocks
(add-hook 'org-mode-hook (lambda ()
			   "Beautify Org Src blocks"
			   (push '("#+begin_src" . "λ") prettify-symbols-alist)
			   (push '("#+end_src" . "λ") prettify-symbols-alist)
			   (prettify-symbols-mode)))

;; All headings (*) use custom font
(add-hook 'org-mode-hook
	  (lambda ()
	    (dolist (org-headings org-level-faces)
	      (set-face-attribute org-headings nil :family "IBM Plex Sans"))))

;; Elimate org magic removing empty lines between headings when they're toggled closed
(setq org-blank-before-new-entry '((heading . nil)
				   (plain-list-item . nil)))
(setq org-cycle-separator-lines 1)

;; Enabling displaying images by default
(setq org-startup-with-inline-images t)

;; Start spellchecker for every org buffer
(add-hook 'org-mode-hook 'turn-on-flyspell)

(org-babel-do-load-languages
 'org-babel-load-languages
 '((shell . t)
   (python . t)))

;; Set org-agenda files
(setq org-agenda-files (quote ("~/doc/agenda/")))

;; Org Capture
(setq org-capture-templates
      `(("i" "inbox" entry (file "~/doc/agenda/inbox.org")
	 "* TODO %?")
	("c" "org-protocol-capture" entry (file "~/doc/agenda/inbox.org")
	 "* TODO [[%:link][%:description]]\n\n %i" :immediate-finish t)
	("p" "org-protocol-projects" entry (file "~/doc/notes/Projects.org")
	 "* TODO [[%:link][%:description]]\n\n %i" :immediate-finish t)))

;; Closing items
(setq org-log-done 'note)

;; Remove / and * emphasis for italics and bold respectively
(setq org-hide-emphasis-markers t)

;; Replace ... for hidden content with ⤵
(setq org-ellipsis "⤵")

;; - List replaced with •
(font-lock-add-keywords 'org-mode
			'(("^ *\\([-]\\) "
			   (0 (prog1 () (compose-region (match-beginning 1) (match-end 1) "•"))))))

;; Enable auto-fill mode (limit M-q)
(add-hook 'text-mode-hook 'turn-on-auto-fill)

(define-key global-map (kbd "C-c o l") 'org-store-link)
(define-key global-map (kbd "C-c o a") 'org-agenda-list)
(define-key global-map (kbd "C-c o c") 'org-capture)
(define-key global-map (kbd "C-c o b") 'org-iswitchb)

(use-package htmlize)
;; HTML5 export
(setq org-html-html5-fancy t)

(use-package org-superstar
  :after org
  :hook (org-mode . org-superstar-mode)
  :custom
  (org-hide-leading-stars t))

(use-package org-protocol
  :straight nil)

;; Differentiate between URL links and other links
;;(org-link-set-parameters "http" :face '(:box t))
;;(org-link-set-parameters "https" :face '(:box t))

(defun org-link-make-external-string (orig-fun link description)
  "Add external link icon in DESCRIPTION when LINK is http(s).
Then call ORIG-FUN."
  (if (or (string= (url-type (url-generic-parse-url link)) "http")
	  (string= (url-type (url-generic-parse-url link)) "https"))
      (setq description (concat "  " description)))
  (apply orig-fun (list link description)))

;; All external links have icon appended to them
(advice-add 'org-link-make-string :around #'org-link-make-external-string)

(use-package webfeeder)

(use-package ox-publish
  :straight nil
  :config
  (setq bassamsaeed.ca/base-directory "~/src/bassamsaeed.ca/")
  (setq bassamsaeed.ca/header-file (concat bassamsaeed.ca/base-directory "partials/header.html"))
  (setq bassamsaeed.ca/footer-file (concat bassamsaeed.ca/base-directory "partials/footer.html"))

  (defun bassamsaeed.ca/header (_plist)
    "Header"
    (with-temp-buffer
      (insert-file-contents bassamsaeed.ca/header-file)
      (buffer-string)))

  (defun  bassamsaeed.ca/footer (_plist)
    "Footer"
    (with-temp-buffer
      (insert-file-contents bassamsaeed.ca/footer-file)
      (buffer-string)))

  (defun bassamsaeed.ca/filter-index-links (link backend info)
    "Convert index.html links to just their root directory"
    (if (org-export-derived-backend-p backend 'html)
	(replace-regexp-in-string "/index.html" "/" link)))

  (defun bassamsaeed.ca/org-sitemap-format (title list)
    "Remove subtitle in posts index page"
    (let ((filtered-list (cl-remove-if (lambda (x)
					 (and (sequencep x) (null (car x))))
				       list)))
      (concat "#+TITLE: " title "\n"
	      "#+HTML_HEAD: <link rel=\"stylesheet\" type=\"text/css\" href=\"/css/main.css\">\n"
	      "#+HTML_HEAD: <link rel=\"alternate\" type=\"application/rss+xml\" href=\"/posts.rss\">\n"
	      "#+HTML_HEAD: <link rel=\"alternate\" type=\"application/atom+xml\" href=\"/posts.atom\">\n"
	      "#+HTML_HEAD: <style>.subtitle{display: none;}</style>\n"
       (org-list-to-org filtered-list))))

  (defun bassamsaeed.ca/org-sitemap-format-entry (entry style project)
    ""
    (format "%s /[[file:%s][%s]]/"
	    (format-time-string "%b %d, %Y" (org-publish-find-date entry project))
	    entry
	    (org-publish-find-title entry project)))

  (defun bassamsaeed.ca/org-html-publish-to-html (plist filename pub-dir)
    "Wrapper function around org-html-publish-to-html to include Date in Title"
    (let ((project (cons 'rw plist)))
      (plist-put plist :subtitle
		 (format-time-string "%b %d, %Y" (org-publish-find-date filename project)))
      (org-html-publish-to-html plist filename pub-dir)))

  (defun bassamsaeed.ca/publish ()
    (interactive)
    (setq webfeeder-default-author "Bassam Saeed <bassam.saeed@gmail.com>")
    (webfeeder-build
     "posts.atom"
     (concat bassamsaeed.ca/base-directory "public")
     "https://www.bassamsaeed.ca"
     (delete "posts/index.html"
	     (mapcar (lambda (f) (replace-regexp-in-string ".*/public/" "" f))
		     (directory-files-recursively
		      (concat bassamsaeed.ca/base-directory "public/posts") "index.html")))
     :title "Bassam Saeed's Blog"
     :description "Personal Development Blog")
    (webfeeder-build
     "posts.rss"
     (concat bassamsaeed.ca/base-directory "public")
     "https://www.bassamsaeed.ca"
     (delete "posts/index.html"
	     (mapcar (lambda (f) (replace-regexp-in-string ".*/public/" "" f))
		     (directory-files-recursively
		      (concat bassamsaeed.ca/base-directory "public/posts") "index.html")))
     :title "Bassam Saeed's Blog"
     :description "Personal Development Blog"
     :builder 'webfeeder-make-rss))

  (setq org-publish-project-alist
	`(("posts"
	   :base-directory ,(concat bassamsaeed.ca/base-directory "posts/")
	   :publishing-directory ,(concat bassamsaeed.ca/base-directory "public/posts")
	   :base-extension "org"
	   :publishing-function bassamsaeed.ca/org-html-publish-to-html
	   :recursive t
	   :html-head
	   ,(concat
	    "<link rel=\"stylesheet\" type=\"text/css\" href=\"/css/main.css\">\n"
	    "<link rel=\"alternate\" type=\"application/rss+xml\" href=\"/posts.rss\">\n"
	    "<link rel=\"alternate\" type=\"application/atom+xml\" href=\"/posts.atom\">\n")
	   :html-head-include-default-style nil
	   :html-head-include-scripts nil
	   :html-preamble bassamsaeed.ca/header
	   :html-postamble bassamsaeed.ca/footer
	   :section-numbers nil
	   :with-toc nil
	   :auto-sitemap t
	   :sitemap-filename "index.org"
	   :sitemap-title "Posts"
	   :sitemap-style list
	   :sitemap-format-entry bassamsaeed.ca/org-sitemap-format-entry
	   :sitemap-function bassamsaeed.ca/org-sitemap-format
	   :sitemap-sort-files anti-chronologically)

	  ("assets"
	   :base-directory ,(concat bassamsaeed.ca/base-directory "assets/")
	   :publishing-directory ,(concat bassamsaeed.ca/base-directory "public/")
	   :recursive t
	   :base-extension "css\\|svg\\|woff2"
	   :publishing-function org-publish-attachment)

	  ("static"
	   :base-directory ,(concat bassamsaeed.ca/base-directory "static/")
	   :publishing-directory ,(concat bassamsaeed.ca/base-directory "public/")
	   :base-extension "org"
	   :publishing-function org-html-publish-to-html
	   :recursive t
	   :html-head
	   ,(concat
	    "<link rel=\"stylesheet\" type=\"text/css\" href=\"/css/main.css\">\n"
	    "<link rel=\"alternate\" type=\"application/rss+xml\" href=\"/posts.rss\">\n"
	    "<link rel=\"alternate\" type=\"application/atom+xml\" href=\"/posts.atom\">\n")
	   :html-head-include-default-style nil
	   :html-head-include-scripts nil
	   :html-preamble bassamsaeed.ca/header
	   :html-postamble bassamsaeed.ca/footer
	   :section-numbers nil
	   :with-toc nil)

	  ("website" :components ("posts" "assets" "static"))))

  (add-to-list 'org-export-filter-link-functions
	       'bassamsaeed.ca/filter-index-links))

(use-package magit
  :commands magit-status
  :bind (("C-x g" . magit-status)))

(use-package company
  :custom
  (company-idle-delay 0)
  (company-minimum-prefix-length 1)
  :hook
  (prog-mode . company-mode))

(use-package company-box
  :after company
  :hook (company-mode . company-box-mode))

(use-package flycheck
  :commands flycheck-mode)

(use-package yaml-mode
  :mode
  ("\\.yml\\'"))

(use-package elfeed
  :bind
  ("C-x w" . elfeed))

(use-package elfeed-org
  :after elfeed
  :config
  (elfeed-org))

(use-package elfeed-goodies
  :after elfeed
  :config
  (elfeed-goodies/setup))

(use-package elfeed-protocol
  :after elfeed)

(use-package deft
  :after org
  :bind ("C-c n d" . deft)
  :commands (deft)
  :config
  (setq deft-directory "~/doc/notes")
  (setq deft-recursive t)
  (setq deft-default-extension "org")
  (setq deft-use-filename-as-title t)
  (setq deft-use-filter-string-for-filename t))

(use-package dired
  :straight nil
  :bind (:map dired-mode-map
	      ;; by default the binding for mouse-2 is
	      ;; 'dired-mouse-find-file-other-window
	      ([mouse-2] . 'dired-mouse-find-file))
  :custom
  ;; Human readable file sizes
  (dired-listing-switches "-lha")



  ;; Colourful columns
  (use-package diredfl
    :config
    (diredfl-global-mode 1)))

(use-package vterm
  :config
  (setq vterm-shell "/usr/bin/fish")

  ;; Match Xresources colours
  (set-face-attribute 'vterm-color-black nil :foreground "#1c1b19")
  (set-face-attribute 'vterm-color-black nil :background "#918175")
  (set-face-attribute 'vterm-color-red nil :background "#ef2f27")
  (set-face-attribute 'vterm-color-red nil :foreground "#f75341")
  (set-face-attribute 'vterm-color-green nil :foreground "#519f50")
  (set-face-attribute 'vterm-color-green nil :background "#98bc37")
  (set-face-attribute 'vterm-color-yellow nil :foreground "#fbb829")
  (set-face-attribute 'vterm-color-yellow nil :background "#fed06e")
  (set-face-attribute 'vterm-color-blue nil :foreground "#2c78bf")
  (set-face-attribute 'vterm-color-blue nil :background "#68a8e4")
  (set-face-attribute 'vterm-color-magenta nil :foreground "#e02c6d")
  (set-face-attribute 'vterm-color-magenta nil :background "#ff5c8f")
  (set-face-attribute 'vterm-color-cyan nil :foreground "#0aaeb3")
  (set-face-attribute 'vterm-color-cyan nil :background "#53fde9")
  (set-face-attribute 'vterm-color-white nil :foreground "#d0bfa1")
  (set-face-attribute 'vterm-color-white nil :background "#fce8c3")
  :hook (vterm-mode . (lambda ()
			(setq-local global-hl-line-mode nil))))
