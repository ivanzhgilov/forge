(define-module (forge dependency)
  #:use-module ((forge dependency types) #:prefix types:)
  #:export (make-dependency
             dependency?
             dependency-name
             dependency-constraint
             dependency-kind))

(define make-dependency types:make-dependency)
(define dependency? types:dependency?)
(define dependency-name types:dependency-name)
(define dependency-constraint types:dependency-constraint)
(define dependency-kind types:dependency-kind)
