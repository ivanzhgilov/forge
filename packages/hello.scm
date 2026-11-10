(define-module (packages hello)
  #:use-module (forge package)
  #:export (package))

(define package
  (make-package
    "hello"
    "1.0"
    "./sources/hello"
    '()))

