(define-module (forge package-loader)
  #:use-module (forge package)
  #:export (load-package))

(define (load-package name)
  (let* ((module-name
          (list 'packages (string->symbol name)))
         (interface
          (resolve-interface module-name))
         (package
          (module-ref interface 'package)))
    (if (package? package)
        package
        (error "package recipe did not export a valid package" name))))
