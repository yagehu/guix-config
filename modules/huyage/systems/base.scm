(define-module (huyage systems base)
  #:use-module (gnu)
  #:use-module (gnu packages certs)
  #:use-module (gnu packages version-control)
  #:use-module (gnu packages vim)
  #:use-module (nongnu packages linux)
  #:use-module (nongnu system linux-initrd)
)

(define-public base-operating-system
  (operating-system
    (host-name "burrow")
    (locale "en_US.utf8")

    ;; Non-free Linux and firmware.
    (kernel linux)
    (firmware (list linux-firmware))
    (initrd microcode-initrd)

    (keyboard-layout (keyboard-layout "us"))

    (bootloader (bootloader-configuration
      (bootloader grub-efi-bootloader)
      (targets (list "/boot/efi"))
      (keyboard-layout keyboard-layout)
    ))

    (packages
      (append
        (list
          git
          neovim
          nss-certs
        )
        %base-packages
      )
    )

    ;; Must be overriden.
    (file-systems
      (cons*
        (file-system
          (mount-point "/tmp")
          (device "none")
          (type "tmpfs")
          (check? #f)
        )
        %base-file-systems
      )
    )
  )
)


