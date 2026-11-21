(define-module (forge package types)
  #:use-module (srfi srfi-1)
  #:use-module (srfi srfi-9)
  #:use-module (forge dependency)
  #:use-module (forge version)
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

(define (non-empty-string? value)
  (and (string? value)
       (> (string-length value) 0)))

(define (make-package name version source dependencies)
  (unless (non-empty-string? name)
    (error "package name must be a non-empty string" name))

  (unless (version? version)
    (error "package version must be a version object" version))

  (unless (non-empty-string? source)
    (error "package source must be a non-empty string" source))

  (unless (and (list? dependencies)
               (every dependency? dependencies))
    (error "package dependencies must be a list of dependencies"
           dependencies))

  (%make-package name version source dependencies))
