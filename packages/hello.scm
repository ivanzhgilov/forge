; example package
(define-module (packages hello)
  #:use-module (forge package)
  #:use-module (forge version)
  #:export (packages))

(define packages
  (list
    (make-package
      "hello"
      (string->version "1.0")
      "./sources/hello"
      '())))
