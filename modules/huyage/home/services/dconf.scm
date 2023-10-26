(define-module (huyage home services dconf)
  #:use-module (gnu home services)
  #:use-module (gnu packages gnome)
  #:use-module (guix derivations)
  #:use-module (guix gexp)
  #:use-module (guix store)
  #:export (home-dconf-load-service-type))

(define (dconf-load-gexp settings)
  #~(begin
      (use-modules (ice-9 popen))
      
      (define (alist-value-print value)
        (define (list-vals lv) (string-join (map alist-value-print lv) ", "))
        ((@ (ice-9 match) match) value
          [#t "true"]
          [#f "false"]
          [(? string? str) (format #f "'~a'" str)]
          [(entries ...)
           (format #f "(~a)" (list-vals entries))]
          [#(entries ...)
           (format #f "[~a]" (list-vals entries))]
          [v (format #f "~a" v)]))
     
      (define (alist->ini al)
        (string-concatenate
         (map
          ((@ (ice-9 match) match-lambda)
            [(top-level-path entries ...)
             (format #f "[~a]~%~a~%" top-level-path
	             (string-concatenate
		      (map
		       ((@ (ice-9 match) match-lambda)
		         [(var value)
		          (format #f "~a=~a~%" var (alist-value-print value))])
		       entries)))]) al)))
      
      (let ([dc-pipe (open-pipe* OPEN_WRITE #$(file-append dconf "/bin/dconf") "load" "/")])
	(display (alist->ini #$settings) dc-pipe))))

(define home-dconf-load-service-type
  (service-type (name 'dconf-load-service)
		(extensions
		 (list
		  (service-extension
		   home-activation-service-type
		   dconf-load-gexp)))
		(default-value '())
		(description "Loads an Alist of INI Dconf entries on activation")))
