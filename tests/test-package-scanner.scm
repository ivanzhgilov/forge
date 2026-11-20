(define-module (tests test-package-scanner)
  #:use-module (srfi srfi-64)
  #:use-module (forge package)
  #:export (run-tests))

(define (run-tests)
  (let ((root "tests/fixtures/package-recipes"))

    (test-begin "package scanner")

    (test-equal "find recipes recursively"
                (list
                  (string-append root "/core/system.scm")
                  (string-append root "/development/compiler.scm"))
                (scan-package-recipes root))

    (test-equal "ignore non-scheme files"
                '()
                (scan-package-recipes
                  (string-append root "/empty")))

    (test-error "reject non-directory path"
                #t
                (scan-package-recipes
                  (string-append root "/core/notes.txt")))

    (test-error "reject missing directory"
                #t
                (scan-package-recipes
                  (string-append root "/missing")))

    (test-error "reject non-string path"
                #t
                (scan-package-recipes 123))

    (test-end "package scanner")))
