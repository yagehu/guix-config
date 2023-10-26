(define-module (huyage systems bush)
  #:use-module (gnu)
  #:use-module (gnu packages shells)
  #:use-module (huyage systems base)
)

(use-service-modules cups desktop ssh xorg)

(operating-system
  (inherit base-operating-system)

  (host-name "bush")

  (users (cons* (user-account
                  (name "huyage")
                  (comment "Yage Hu")
                  (group "users")
                  (home-directory "/home/huyage")
                  (shell (file-append zsh "/bin/zsh"))
                  (supplementary-groups '("wheel" "netdev" "audio" "video")))
                %base-user-accounts))

  (packages (append (list (specification->package "i3-wm")
                          (specification->package "i3status")
                          (specification->package "dmenu")
                          (specification->package "st")
                          (specification->package
                           "emacs-desktop-environment"))
                    %base-packages))

  ;; Below is the list of system services.  To search for available
  ;; services, run 'guix system search KEYWORD' in a terminal.
  (services
    (modify-services
      (append (list (service gnome-desktop-service-type)
                    (service xfce-desktop-service-type)

                    ;; To configure OpenSSH, pass an 'openssh-configuration'
                    ;; record as a second argument to 'service' below.
                    (service openssh-service-type)
                    (service cups-service-type)
                    ;;(set-xorg-configuration
                    ;; (xorg-configuration (keyboard-layout keyboard-layout)))
                    )

              ;; This is the default list of services we
              ;; are appending to.
              %desktop-services)
      (guix-service-type config =>
        (guix-configuration
          (inherit config)
          (substitute-urls (append (list "https://substitute.nonguix.org") %default-substitute-urls))
          (authorized-keys (append (list (local-file "../../../nonguix-signing-key.pub")) %default-authorized-guix-keys))
        )
      )
    )
  )

  (bootloader (bootloader-configuration
    (bootloader grub-bootloader)
    (targets (list "/dev/sda"))
    (keyboard-layout (keyboard-layout "us"))
  ))

  (swap-devices (list (swap-space
    (target (uuid "01e471a2-5e4d-4c20-aa8d-1073246c7518"))
  )))

  ;; The list of file systems that get "mounted".  The unique
  ;; file system identifiers there ("UUIDs") can be obtained
  ;; by running 'blkid' in a terminal.
  (file-systems (cons* (file-system
                         (mount-point "/")
                         (device (uuid
                                  "2137d8b7-599d-49c9-9551-679c37c54e54"
                                  'ext4))
                         (type "ext4")) %base-file-systems))
)
