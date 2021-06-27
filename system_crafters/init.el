(defun window-split-toggle ()
  (interactive)
  (if (> (length (window-list)) 2)
      (error "Can't toggle with more than 2 windows!")
    (let ((func (if (window-full-height-p)
                    #'split-window-vertically
                  #'split-window-horizontally)))
      (delete-other-windows)
      (funcall func)
      (save-selected-window
        (other-window 1)
        (switch-to-buffer (other-buffer))))))

(defun efs/org-mode-setup ()
  (org-indent-mode)
  (variable-pitch-mode 1)
  (visual-line-mode)
)

; initialize package sources
(require 'package)

;; sets the links to the package repositories
(setq package-archives '(
                         ("melpa" . "https://melpa.org/packages/")
                         ("melpa-stable" . "https://stable.melpa.org/packages/")
                         ("org" . "https://orgmode.org/elpa/")
                         ("elpa" . "https://elpa.gnu.org/packages/")
                        )
)

;; loads emacs packages and activate them
(package-initialize)

;; check if package-archive-contents is present
;; if there are no pachage archive (downloaded packages)
;; on the computer, download them
(unless package-archive-contents
 (package-refresh-contents))

;; tries to install use-package if it's not already installed
(unless (package-installed-p 'use-package)
  (package-install 'use-package)
)

;; loads use-package package
(require 'use-package)

;; use-package-always-ensure makes it so
;; when require is used on a package
;; if the package is not downloaded
;; it will download it before
;; activating it
(setq use-package-always-ensure t)
;; Enable use-package-always-ensure
;; if you wish this behavior to be
;; global for all packages:
;;
;; https://github.com/jwiegley/use-package

(setq inhibit-startup-message t)

(scroll-bar-mode -1) ; disable visible scrollbar
(tool-bar-mode -1) ; disable the toolbar
(tooltip-mode -1) ; disable tooltips
(menu-bar-mode -1) ; disable the menu bar

(set-fringe-mode 10) ; give some breathin room?

(setq visible-bell t)

(set-face-attribute 'default nil
                    :font "Fira Code"
                    :height 140
)

;; set the fixed pitch font face
(set-face-attribute 'fixed-pitch nil
                    :font "Fira Code"
                    :height 140
)

;; set hte variable pitch font face
(set-face-attribute 'variable-pitch nil
                    :font "Prociono"
                    :height 150
                    :weight 'regular
                    )

(use-package doom-themes)
(load-theme 'doom-dracula t)

(use-package command-log-mode)

(use-package swiper
  :ensure t)

(use-package ivy
  ;; diminish hides the minor mode 
  ;; from the modeline
  :diminish
  :bind (
	 ("M-s" . swiper)
         :map ivy-minibuffer-map
         ("TAB" . ivy-alt-done)	
         ("C-l" . ivy-alt-done)
         ("C-j" . ivy-next-line)
         ("C-k" . ivy-previous-line)
         :map ivy-switch-buffer-map
         ("C-k" . ivy-previous-line)
         ("C-l" . ivy-done)
         ("C-d" . ivy-switch-buffer-kill)
         :map ivy-reverse-i-search-map
         ("C-k" . ivy-previous-line)
         ("C-d" . ivy-reverse-i-search-kill)
	)
  :config
  (ivy-mode 1)
)

(use-package counsel
  :ensure t)

(global-set-key
 (kbd "<escape>") 'keyboard-escape-quit
)

(use-package doom-modeline
  :ensure t
  :init (doom-modeline-mode 1)
  :custom (
	      (doom-modeline-height 10)
	    )
)

(column-number-mode)
(global-display-line-numbers-mode t)

(dolist
  (mode '(org-mode-hook
          term-mode-hook
          shell-mode-hook
          eshel-mode-hook
         )
  )
  (add-hook mode (lambda ()
                 (display-line-numbers-mode 0)
                 )
  )
)

(use-package rainbow-delimiters
  :hook (prog-mode . rainbow-delimiters-mode))

(use-package which-key
  :init (which-key-mode)
  :diminish which-key-mode
  :config (setq which-key-idle-delay 0)
)

(use-package ivy-rich
  :init
  (ivy-rich-mode 1)
)

(use-package counsel
  :bind (
         ("M-x" . counsel-M-x)
         ("C-x b" . counsel-buffer)
         ("C-x C-f" . counsel-find-file)
         :map minibuffer-local-map
         ("C-r" . 'counsel-minibuffer-history)
        )
  :config
)

(use-package helpful
  :ensure t
  :custom
  (counsel-describe-function-function #'helpful-callable)
  (counsel-describe-variable-function #'helpful-callable)
  :bind
  ([remap describe-function] . counsel-describe-function)
  ([remap describe-command] . helpful-command)
  ([remap describe-variable] . counsel-describe-variable)
  ([remap describe-key] . helpful-key)
)

(use-package all-the-icons)

(use-package general)	  

;; (general-define-key
 ;; it can be a list of 
 ;; keybindings also:
 ;; "C-M-k" 'some-function
 ;; "C-M-j" 'counsel-switch-buffer
;; )

(use-package general
  :config
  (general-create-definer rune/leader-keys
    :keymaps '(normal insert visual emacs)
    :prefix "SPC"
    :global-prefix "C-SPC")

  (rune/leader-keys
   "t" '(
         :ignore t
         :which-key "toggles"
         )
   "tt" '(counsel-load-theme :which-key "choose theme")
   "fs" '(save-buffer :which-key "save buffer")
   "ss" '(swiper :which-key "search")
   ":" '(counsel-M-x :which-key "run command")
   "ff" '(counsel-find-file :which-key "find file")
   ";" '(eval-last-sexp :which-key "eval expression")
   "TAB" '(counsel-switch-buffer :which-key "switch buffer")
   "bd" '(kill-buffer :which-key "delete buffer")
   "bk" '(kill-buffer :which-key "kill buffer")
   "bn" '(next-buffer :which-key "next buffer")
   "bp" '(previous-buffer :which-key "previous buffer")
   "qq" '(save-buffers-kill-emacs :which-key "quit emacs")

   ;; not working?
   "tw" '(window-split-toggle :which-key "toggle window split h/v")
  )
)

(use-package evil
  :init
  (setq evil-want-integration t)
  (setq evil-want-keybinding nil)
  (setq evil-want-C-u-scroll t)
  (setq evil-want-C-i-jump nil)
  :config
  (evil-mode 1) 
  ;; bind keys only in insert mode
  ;; (define-key evil-insert-state-map (kbd "C-g") 'evil-normal-state)
  ;; (define-key-evil-insert-state-map (kbd "C-h") 'evil-delete-backward-char-and-join)

  ;;use visual line motions even outside of visual-line-mode buffers 
  ;; AH! this is a config that I noticed changing in doom-emacs
  ;;
  ;; it makes the cursor interpret warpped-around lines as more than one line
  ;;
  ;; by default the warpped line is considered one line until the very end
  (evil-global-set-key 'motion "j" 'evil-next-visual-line)
  (evil-global-set-key 'motion "k" 'evil-previous-visual-line)
  ;;strangelly_it_is_not_working

  ;; (evil-set-initial-state 'messages-buffer-mode 'normal)
  (evil-set-initial-state 'dashboard 'normal)
)

  ;; IMPORTANT! C-z puts you in emacs-mode
  ;; a mode where evil-keybindings don't work
  ;; I struggled with that in the past

(global-set-key (kbd "C-s") 'save-buffer)

(use-package evil-collection
  :after evil
  :config
  (evil-collection-init))

(use-package hydra) 

(defhydra hydra-text-scale (
			    :timeout 5
			   )
  "scale text"
  ("j" text-scale-increase "in")
  ("k" text-scale-decrease "out")
  ("f" nil "finished" :exit t)
)

(rune/leader-keys
  "ts" '(hydra-text-scale/body :which-key "scale text"))

(use-package projectile
  :diminish projectile-mode
  :config (projectile-mode)
  :custom ((projectile-completion-system 'ivy))
  :bind-keymap
  ("C-c p" . projectile-command-map)
  :init
  (when (file-directory-p "~/Projects")
    (setq projectile-project-search-path '("~/Projects"))
  )
  (setq projectile-switch-project-action #'projectile-dired)
)

(use-package counsel-projectile
  :config (counsel-projectile-mode)
)

(use-package magit

  ;; makes the diff window 
  ;; happen in the same window you are in
  ;; the defalt is showing another window
  :custom
  (magit-display-buffer-function #'magit-display-buffer-same-windows-except-diff-v1)
)

(use-package forge)

(use-package org
  :hook (org-mode . efs/org-mode-setup)
  :config
  (setq org-ellipsis " ▾"
	;; the following config 
;; hide the formatting tags like *word* 
	org-hide-emphasis-markers t
  )
)

(use-package org-appear
  :hook (org-mode . org-appear-mode))

(use-package org-bullets
  :after org
  :hook (org-mode . org-bullets-mode)
  :custom
;; his lame bullets
;;  (org-bullets-bullet-list '("◉" "○" "●" "○" "●" "○" "●")
  (org-bullets-bullet-list '(
			     "➀"
			     "➁"
			     "➂"
			     "➃"
			     "➄"
			     "➅"
			     "➆"
			     "➇"
			     "➈"
			     "➉"
			     )
  )
)

(use-package org
  :config

    (defun efs/org-font-setup ()
    ;; Replace list hyphen with dot
    (font-lock-add-keywords 'org-mode
			    '(("^ *\\([-]\\) "
				(0 (prog1 () (compose-region (match-beginning 1) (match-end 1) "•"))))))

    ;; Set faces for heading levels
    (dolist (face '((org-level-1 . 1.2)
		    (org-level-2 . 1.1)
		    (org-level-3 . 1.05)
		    (org-level-4 . 1.0)
		    (org-level-5 . 1.1)
		    (org-level-6 . 1.1)
		    (org-level-7 . 1.1)
		    (org-level-8 . 1.1)))
	(set-face-attribute (car face) nil :font "Prociono" :weight 'regular :height (cdr face)))

    ;; Ensure that anything that should be fixed-pitch in Org files appears that way
    (set-face-attribute 'org-block nil :foreground nil :inherit 'fixed-pitch)
    (set-face-attribute 'org-code nil   :inherit '(shadow fixed-pitch))
    (set-face-attribute 'org-table nil   :inherit '(shadow fixed-pitch))
    (set-face-attribute 'org-verbatim nil :inherit '(shadow fixed-pitch))
    (set-face-attribute 'org-special-keyword nil :inherit '(font-lock-comment-face fixed-pitch))
    (set-face-attribute 'org-meta-line nil :inherit '(font-lock-comment-face fixed-pitch))
    (set-face-attribute 'org-checkbox nil :inherit 'fixed-pitch)
    )

  (efs/org-font-setup)

;; replace list of hiphens with a dot
(font-lock-add-keywords 'org-mode
			'(
			  ("^ *\\([-]\\) "
			   (0 (prog1 ()
				(compoese-region (match-beginning 1)
						 (match-end 1)
						 "•"
						 )
			      )
			   )
			  )
			 )
)

;; Ensure that anything that should be fixed-pitch in Org files appears that way
(set-face-attribute 'org-block nil
		    :foreground nil
		    :inherit 'fixed-pitch
		    )

(set-face-attribute 'org-code nil
		    :inherit '(shadow fixed-pitch)
		    )

(set-face-attribute 'org-table nil
		    :inherit '(shadow fixed-pitch)
		    )

(set-face-attribute 'org-verbatim nil
		    :inherit '(shadow fixed-pitch)
		    )

(set-face-attribute 'org-special-keyword nil
		    :inherit '(font-lock-comment-face fixed-pitch)
		    )

(set-face-attribute 'org-meta-line nil
		    :inherit '(font-lock-comment-face fixed-pitch)
		    )

(set-face-attribute 'org-checkbox nil
		    :inherit 'fixed-pitch
		    )

;; davewill's config:
;;    (dolist (face '((org-level-1 . 1.5)
;;		    (org-level-2 . 1.45)
;;		    (org-level-3 . 1.4)
;;		    (org-level-4 . 1.35)
;;		    (org-level-5 . 1.3)
;;		    (org-level-6 . 1.25)
;;		    (org-level-7 . 1.2)
;;		    (org-level-8 . 1.1)
;;		)
;;	    )
;;      )
;;
;;  (set-face-attribute (car face) nil
;;		      :font "Prociono"
;;		      :weight 'regular
;;		      :height (cdr face)
;;  )
)

(use-package org
  :config

    (defun efs/org-mode-visual-fill ()
	(setq visual-fill-column-width 100
		visual-fill-column-center-text t)
	(visual-fill-column-mode 1)
    )

    (use-package visual-fill-column
      :hook (org-mode . efs/org-mode-visual-fill)
    )
)

(use-package org
  :config 

  ;; shows the completion logs in 
  ;; agenda view
  (setq org-agenda-start-with-log-mode t)

  ;; logs the time of the completion 
  ;; of a task
  (setq org-log-done 'time)

  ;; folds all the done logging 
  ;; into a single colalpsable drawer
  (setq org-log-into-drawer t)

  (setq
   org-agenda-files
'(
"~/.system-crafters/orgfiles/tasks.org"
"~/.system-crafters/orgfiles/birthdays.org"
)
  )
)

;; org todo states
(use-package org
  :config
  (setq org-todo-keywords
   '(
	(sequence
	"TODO(t)"
	"NEXT(n)"
	"|"
	"DONE(d)"
	)
	(sequence
	"BACKLOG(b)"
	"PLAN(p)"
	"ACTIVE(a)" 
	"REVIEW(v)"
	"WAIT(w@/!)"
	"|"
	"COMPLETED(c)"
	"CANCELED(k@)"
	)
    )
  )
)

(use-package org
  :config
    (setq org-agenda-custom-commands
    '(("d" "Dashboard"
	((agenda "" ((org-deadline-warning-days 7)))
	(todo "NEXT"
	    ((org-agenda-overriding-header "Next Tasks")))
	(tags-todo "agenda/ACTIVE" ((org-agenda-overriding-header "Active Projects")))))

	("n" "Next Tasks"
	((todo "NEXT"
	    ((org-agenda-overriding-header "Next Tasks")))))

	("W" "Work Tasks" tags-todo "+work-email")

	;; Low-effort next actions
	("e" tags-todo "+TODO=\"NEXT\"+Effort<15&+Effort>0"
	((org-agenda-overriding-header "Low Effort Tasks")
	(org-agenda-max-todos 20)
	(org-agenda-files org-agenda-files)))

	("w" "Workflow Status"
	((todo "WAIT"
		((org-agenda-overriding-header "Waiting on External")
		(org-agenda-files org-agenda-files)))
	(todo "REVIEW"
		((org-agenda-overriding-header "In Review")
		(org-agenda-files org-agenda-files)))
	(todo "PLAN"
		((org-agenda-overriding-header "In Planning")
		(org-agenda-todo-list-sublevels nil)
		(org-agenda-files org-agenda-files)))
	(todo "BACKLOG"
		((org-agenda-overriding-header "Project Backlog")
		(org-agenda-todo-list-sublevels nil)
		(org-agenda-files org-agenda-files)))
	(todo "READY"
		((org-agenda-overriding-header "Ready for Work")
		(org-agenda-files org-agenda-files)))
	(todo "ACTIVE"
		((org-agenda-overriding-header "Active Projects")
		(org-agenda-files org-agenda-files)))
	(todo "COMPLETED"
		((org-agenda-overriding-header "Completed Projects")
		(org-agenda-files org-agenda-files)))
	(todo "CANC"
		((org-agenda-overriding-header "Cancelled Projects")
		(org-agenda-files org-agenda-files))))))
    )
)

(use-package org
  :config
    ;; tags in org mode
    (setq org-tag-alist
	'(
	    (:startgroup)
	    ; Put mutually exclusive tags here
	    (:endgroup)
	    ("@errand" . ?E)
	    ("@home" . ?H)
	    ("@work" . ?W)
	    ("agenda" . ?a)
	    ("planning" . ?p)
	    ("publish" . ?P)
	    ("batch" . ?b)
	    ("note" . ?n)
	    ("idea" . ?i)
	)
    )
)

(use-package org
  :config
  (setq org-refile-targets
	'(
	  ("archive.org" :maxlevel . 1)
	  ("tasks.org" :maxlevel . 1)
	  )
	)
  ;; save org buffers after refiling
  (advice-add 'org-refile :after 'org-save-all-org-buffers)
)

(use-package org
  :config
  (setq org-capture-templates
   `(
	("t" "Tasks / Projects")
	("tt"
	"Task"
	entry (
	       file+olp
	       "~/.system-crafters/orgfiles/tasks.org"
	       "Inbox"
	)
	"* TODO %?\n  %U\n  %a\n  %i" :empty-lines 1
	)

	("j" "Journal Entries")
	("jj" "Journal" entry
	    (file+olp+datetree "~/.system-crafters/orgfiles/journal.org")
	    "\n* %<%I:%M %p> - Journal :journal:\n\n%?\n\n"
	    ;; ,(dw/read-file-as-string "~/Notes/Templates/Daily.org")
	    :clock-in :clock-resume
	    :empty-lines 1)
	("jm" "Meeting" entry
	    (file+olp+datetree "~/.system-crafters/orgfiles/journal.org")
	    "* %<%I:%M %p> - %a :meetings:\n\n%?\n\n"
	    :clock-in :clock-resume
	    :empty-lines 1)

	("w" "Workflows")
	("we"
	    "Checking Email"
	    entry (
		    file+olp+datetree "~/.system-crafters/orgfiles/journal.org"
	    )
	    "* Checking Email :email:\n\n%?" :clock-in :clock-resume :empty-lines 1
	)

	("m" "Metrics Capture")
	("mw"
	    "Weight"
	    table-line (
		file+headline
		"~/.system-crafters/orgfiles/metrics.org"
		"Weight"
	    )
	"| %U | %^{Weight} | %^{Notes} |" :kill-buffer t
	)
 )
   )
)

;; package org-habit
(use-package org
  :config
  (require 'org-habit)
  (add-to-list 'org-modules 'org-habit)
  (setq org-habit-graph-column 60)
)

(org-babel-do-load-languages
  'org-babel-load-languages
    '(
      (emacs-lisp . t)
      (python . t)
     )
)
;; adds unix config files as 
;; an accepted language 
(push '("conf-unix" . conf-unix) 
        org-src-lang-modes)

(setq org-babel-python-command "python3")

(setq org-babel-confirm-evaluate nil)

;; Automatically tangle our Emacs.org config file when we save it
(defun efs/org-babel-tangle-config ()
  (when (string-equal (buffer-file-name)
                      (expand-file-name "~/Projects/emacs_configs/system_crafters/emacs.org"))
    ;; Dynamic scoping to the rescue
    (let ((org-confirm-babel-evaluate nil))
      (org-babel-tangle))))

(add-hook 'org-mode-hook
          (lambda () (add-hook 'after-save-hook #'efs/org-babel-tangle-config)))

;; this is required as of Org 9.2
(require 'org-tempo)

(add-to-list 'org-structure-template-alist '("sh" . "src shell"))
(add-to-list 'org-structure-template-alist '("el" . "src emacs-lisp"))
(add-to-list 'org-structure-template-alist '("py" . "src python"))
;; to use type on an org file, 
;; at the start of a line:
;; <el TAB

;; documentation for supported 
;; org-babel languages:
;; https://orgmode.org/worg/org-contrib/babel/languages/index.html
