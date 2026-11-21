(define-module (forge package catalog)
  #:use-module ((forge package types) #:prefix package:)
  #:use-module (forge version)
  #:use-module (ice-9 hash-table)
  #:use-module (srfi srfi-1)
  #:use-module (srfi srfi-9)
  #:export (make-package-catalog
             package-catalog?
             package-catalog-find))

(define-record-type <package-catalog>
  (%make-package-catalog index)
  package-catalog?
  (index catalog-index))

(define (contains-version? packages candidate)
  (any
    (lambda (package)
      (= (version-compare
           (package:package-version package)
           (package:package-version candidate))
         0))
    packages))

(define (make-package-catalog packages)
  (unless (and (list? packages)
               (every package:package? packages))
    (error "package catalog requires a list of packages"
           packages))

  (let ((index (make-hash-table)))
    (for-each
      (lambda (package)
        (let* ((name (package:package-name package))
               (existing (hash-ref index name '())))

          (when (contains-version? existing package)
            (error "duplicate package version"
                   name
                   (version->string
                     (package:package-version package))))

          (hash-set! index
                     name
                     (append existing (list package)))))
      packages)

    (%make-package-catalog index)))

(define (package-catalog-find catalog name)
  (unless (package-catalog? catalog)
    (error "expected a package catalog" catalog))

  (unless (and (string? name)
               (> (string-length name) 0))
    (error "package name must be a non-empty string" name))

  (hash-ref (catalog-index catalog) name '()))
