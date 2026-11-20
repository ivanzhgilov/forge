(define-module (tests fixtures package-recipes invalid improper-list)
  #:use-module (forge package)
  #:use-module (forge version)
  #:export (packages))

(define packages
  (cons
    (make-package
      "hello"
      (string->version "1.0")
      "./sources/hello"
      '())
    'invalid))
