(define-module (tests test-package-catalog)
  #:use-module (srfi srfi-64)
  #:use-module (forge package)
  #:use-module (forge version)
  #:export (run-tests))

(define (test-package name version)
  (make-package
    name
    (string->version version)
    (string-append "./sources/" name)
    '()))

(define (run-tests)
  (let* ((hello-2 (test-package "hello" "2.0"))
         (hello-1 (test-package "hello" "1.0"))
         (compiler (test-package "compiler" "1.5"))
         (catalog
           (make-package-catalog
             (list hello-2 hello-1 compiler))))

    (test-begin "package catalog")

    (test-assert "package catalog type"
                 (package-catalog? catalog))

    (test-assert "empty package catalog type"
                 (package-catalog?
                   (make-package-catalog '())))

    (test-equal "find multiple versions"
                2
                (length
                  (package-catalog-find catalog "hello")))

    (test-eq "preserve package insertion order"
             hello-2
             (car
               (package-catalog-find catalog "hello")))

    (test-eq "find specific package by name"
             compiler
             (car
               (package-catalog-find catalog "compiler")))

    (test-equal "return empty list for missing package"
                '()
                (package-catalog-find catalog "missing"))

    (test-equal "find in empty catalog"
                '()
                (package-catalog-find
                  (make-package-catalog '())
                  "hello"))

    (test-error "reject non-list input"
                #t
                (make-package-catalog 'invalid))

    (test-error "reject improper package list"
                #t
                (make-package-catalog
                  (cons hello-1 'invalid)))

    (test-error "reject non-package elements"
                #t
                (make-package-catalog
                  (list "not a package")))

    (test-error "reject duplicate package version"
                #t
                (make-package-catalog
                  (list
                    (test-package "hello" "1.2")
                    (test-package "hello" "1.2"))))

    (test-error "reject equivalent package versions"
                #t
                (make-package-catalog
                  (list
                    (test-package "hello" "1.2")
                    (test-package "hello" "1.2.0"))))

    (test-error "reject invalid catalog argument"
                #t
                (package-catalog-find 'invalid "hello"))

    (test-error "reject invalid package name"
                #t
                (package-catalog-find catalog ""))

    (test-end "package catalog")))
