;; This is an operating system configuration generated
;; by the graphical installer.
;;
;; Once installation is complete, you can learn and modify
;; this file to tweak the system configuration, and pass it
;; to the 'guix system reconfigure' command to effect your
;; changes.


;; Indicate which modules to import to access the variables
;; used in this configuration.
(use-modules
  (gnu)
  (gnu packages shells)
  (nongnu packages linux)
)
(use-service-modules cups desktop networking ssh xorg)

(operating-system
  (kernel linux)
  (firmware (list linux-firmware))
  (locale "en_US.utf8")
  (timezone "America/Los_Angeles")
  (keyboard-layout (keyboard-layout "us"))
  (host-name "electric-bunny")

  ;; The list of user accounts ('root' is implicit).
  (users (cons* (user-account
                  (name "huyage")
                  (comment "Yage Hu")
                  (group "users")
                  (home-directory "/home/huyage")
                  (shell (file-append zsh "/bin/zsh"))
                  (supplementary-groups '("wheel" "netdev" "audio" "video")))
                %base-user-accounts))

  ;; Packages installed system-wide.  Users can also install packages
  ;; under their own account: use 'guix search KEYWORD' to search
  ;; for packages and 'guix install PACKAGE' to install a package.
  (packages (append (list (specification->package "i3-wm")
                          (specification->package "i3status")
                          (specification->package "dmenu")
                          (specification->package "st")
                          (specification->package "emacs")
                          (specification->package "emacs-exwm")
                          (specification->package
                           "emacs-desktop-environment")
                          (specification->package "make")
                          (specification->package "nss-certs"))
                    %base-packages))

  ;; Below is the list of system services.  To search for available
  ;; services, run 'guix system search KEYWORD' in a terminal.
  (services
    (modify-services
      (append (list (service bluetooth-service-type)
                    (service gnome-desktop-service-type)
                    (service cups-service-type)
                    (set-xorg-configuration
                     (xorg-configuration (keyboard-layout keyboard-layout))))

              ;; This is the default list of services we
              ;; are appending to.
              %desktop-services)
      (guix-service-type config => (guix-configuration
        (inherit config)
	(substitute-urls (append (list "https://substitutes.nonguix.org")
          %default-substitute-urls
	))
	(authorized-keys
	  (append
	    (list (local-file "nonguix-signing-key.pub"))
	    %default-authorized-guix-keys
	  )
        )
      ))
    )
  )
  (bootloader (bootloader-configuration
                (bootloader grub-efi-bootloader)
                (targets (list "/boot/efi"))
                (keyboard-layout keyboard-layout)))
  (mapped-devices (list (mapped-device
                          (source (uuid
                                   "f53842af-7bd5-4d87-813d-4c2daef4cddb"))
                          (target "cryptroot")
                          (type luks-device-mapping))))

  ;; The list of file systems that get "mounted".  The unique
  ;; file system identifiers there ("UUIDs") can be obtained
  ;; by running 'blkid' in a terminal.
  (file-systems (cons* (file-system
                         (mount-point "/boot/efi")
                         (device (uuid "87E6-0C83"
                                       'fat32))
                         (type "vfat"))
                       (file-system
                         (mount-point "/")
                         (device "/dev/mapper/cryptroot")
                         (type "ext4")
                         (dependencies mapped-devices)) %base-file-systems)))
