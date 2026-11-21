(define-module (tests fixtures package-recipes core system)
  #:use-module (forge package)
  #:use-module (forge version)
  #:export (packages))

(define packages
  (list
    (make-package
      "hello"
      (string->version "1.0")
      "./sources/hello"
      '())

    (make-package
      "hello-tools"
      (string->version "2.0")
      "./sources/hello-tools"
      '())))
