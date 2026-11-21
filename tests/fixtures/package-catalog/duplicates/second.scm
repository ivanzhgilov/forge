(define-module (tests fixtures package-catalog duplicates second)
  #:use-module (forge package)
  #:use-module (forge version)
  #:export (packages))

(define packages
  (list
    (make-package
      "hello"
      (string->version "1.0")
      "./sources/hello-duplicate"
      '())))
