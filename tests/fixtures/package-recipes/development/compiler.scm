(define-module (tests fixtures package-recipes development compiler)
  #:use-module (forge package)
  #:use-module (forge version)
  #:export (packages))

(define packages
  (list
    (make-package
      "compiler"
      (string->version "1.5")
      "./sources/compiler"
      '())))
