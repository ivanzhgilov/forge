(define-module (forge cli)
  #:export (main))

(define (show-help)
  (display "Usage: forge [OPTION]\n")
  (newline)
  (display "Options:\n")
  (display "  -h, --help       Show this help\n")
  (display "  -V, --version    Show version\n"))

(define (show-version)
  (display "Forge 0.1.0\n"))

(define (main argv)
  (let ((args (cdr argv)))
    (cond
      ((null? args)
       (show-help))

      ((member (car args) '("-h" "--help"))
       (show-help))

      ((member (car args) '("-V" "--version"))
       (show-version))

      (else
       (format (current-error-port)
               "forge: unknown option: ~a\n"
               (car args))
       (exit 2)))))
