(define-module (forge dependency)
  #:use-module (srfi srfi-9)
  #:use-module (forge version)
  #:export (make-dependency
            dependency?
            dependency-name
            dependency-constraint
            dependency-kind))

(define-record-type <dependency>
  (%make-dependency name constraint kind)
  dependency?
  (name dependency-name)
  (constraint dependency-constraint)
  (kind dependency-kind))

(define (make-dependency name constraint kind)
  (unless (and (string? name)
               (> (string-length name) 0))
    (error "dependency name must be a non-empty string" name))

  (unless (version-constraint? constraint)
    (error "invalid version constraint" constraint))

  (unless (memq kind '(build runtime))
    (error "invalid dependency kind" kind))

  (%make-dependency name constraint kind))
