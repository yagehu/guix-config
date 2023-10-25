;; This "home-environment" file can be passed to 'guix home reconfigure'
;; to reproduce the content of your profile.  This is "symbolic": it only
;; specifies package names.  To reproduce the exact same profile, you also
;; need to capture the channels being used, as returned by "guix describe".
;; See the "Replicating Guix" section in the manual.

(use-modules (gnu home)
             (gnu packages)
             (gnu services)
  (guix channels)
  (guix gexp)
  (gnu home services guix)
  (gnu home services shells)
  (huyage packages fonts)
)

(home-environment
  ;; Below is the list of packages that will show up in your
  ;; Home profile, under ~/.guix-home/profile.
  (packages (specifications->packages (list "alacritty"
                                            "emacs-geiser-guile"
                                            "emacs-geiser"
					    "git"
                                            "guile"
                                            "emacs"
					    "emacs-doom-modeline"
					    "emacs-doom-themes"
					    "emacs-exec-path-from-shell"
                                            "emacs-nerd-icons"
					    "emacs-use-package"
					    "emacs-vterm"
					    "emacs-which-key"
					    "font-nerd-fonts-cascadia-code"
					    "libvterm"
                                            "zsh"
                                            "firefox"
                                            "neovim")))

  ;; Below is the list of Home services.  To search for available
  ;; services, run 'guix home search KEYWORD' in a terminal.
  (services
    (list
      (service home-bash-service-type
                  (home-bash-configuration
                   (aliases '(("grep" . "grep --color=auto") ("ll" . "ls -l")
                              ("ls" . "ls -p --color=auto")))
                   (bashrc (list (local-file
                                  "/home/huyage/src/guix-config/.bashrc"
                                  "bashrc")))
                   (bash-profile (list (local-file
                                        "/home/huyage/src/guix-config/.bash_profile"
                                        "bash_profile"))))
      )
      (service home-zsh-service-type
        (home-zsh-configuration
	  (zshrc (list (local-file ".zshrc" "zshrc")))
        )
      )
      (simple-service 'nonguix-channel-service
        home-channels-service-type
        (list
          (channel
            (name 'nonguix)
            (url "https://gitlab.com/nonguix/nonguix")
            (introduction
              (make-channel-introduction
                "897c1a470da759236cc11798f4e0a5f7d4d59fbc"
                (openpgp-fingerprint
	          "2A39 3FFF 68F4 EF7A 3D29  12AF 6F51 20A0 22FB B2D5"
	        )
              )
            )
          )
        )
      )
    )
  )
)
