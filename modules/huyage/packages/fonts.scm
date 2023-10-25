(define-module (huyage packages fonts)
  #:use-module (guix build-system font)
  #:use-module (guix download)
  #:use-module ((guix licenses) #:prefix license:)
  #:use-module (guix packages)
)

(define-public font-nerd-fonts-cascadia-code
  (package
    (name "font-nerd-fonts-cascadia-code")
    (version "3.0.2")
    (source (origin
      (method url-fetch)
      (uri (string-append
        "https://github.com/ryanoasis/nerd-fonts/releases/download/v"
        version
        "/CascadiaCode.zip"
      ))
      (sha256 (base32
	"0wljbhy31ngxfhv4492j9bnfpqvqdbv7f3nfvnwihjn1qcng3376"
      ))
    ))
    (build-system font-build-system)
    (arguments
     `(#:phases
        (modify-phases %standard-phases
          (add-before 'install 'make-files-writable
            (lambda _
              (for-each make-file-writable
                (find-files "." ".*\\.(otf|otc|ttf|ttc)$")
              )
	      #t
            )
          )
        )
      )
    )
    (home-page "https://www.nerdfonts.com/")
    (synopsis "Nerd fonts variant of Cascadia Code font")
    (description "Cascadia Code nerd font.")
    (license license:gpl3+)
  )
)
