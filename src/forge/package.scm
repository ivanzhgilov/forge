(define-module (forge package)
  #:use-module (srfi srfi-9)
  #:export (make-package
            package?
            package-name
            package-version
            package-source
            package-inputs))

(define-record-type <package>
  (make-package name version source inputs)
  package?
  (name package-name)
  (version package-version)
  (source package-source)
  (inputs package-inputs))
