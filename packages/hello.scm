(define-module (packages hello)
  #:use-module (forge package)
  #:use-module (forge version)
  #:export (package))

(define package
  (make-package
    "hello"
    (string->version "1.0")
    "./sources/hello"
    '()))
