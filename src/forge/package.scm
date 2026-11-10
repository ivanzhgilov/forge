(define-module (forge package)
  #:use-module (srfi srfi-1)
  #:use-module (srfi srfi-9)
  #:use-module (forge dependency)
  #:export (make-package
            package?
            package-name
            package-version
            package-source
            package-dependencies))

(define-record-type <package>
  (%make-package name version source dependencies)
  package?
  (name package-name)
  (version package-version)
  (source package-source)
  (dependencies package-dependencies))

(define (make-package name version source dependencies)
  (unless (and (list? dependencies)
               (every dependency? dependencies))
    (error "package dependencies must be a list of dependencies"
           dependencies))

  (%make-package name version source dependencies))

