(define-module (tests test-package)
  #:use-module (srfi srfi-64)
  #:use-module (forge package)
  #:use-module (forge dependency)
  #:use-module (forge version)
  #:export (run-tests))

(define (run-tests)
  (let* ((version (string->version "1.0.0"))
         (dependency
           (make-dependency
             "hello"
             (version-at-least (string->version "1.0"))
             'runtime))
         (package
           (make-package
             "greeting"
             version
             "./sources/greeting"
             (list dependency))))

    (test-begin "package")

    (test-assert "package type"
                 (package? package))

    (test-equal "package name"
                "greeting"
                (package-name package))

    (test-assert "package version is a version object"
                 (version? (package-version package)))

    (test-equal "package version"
                "1.0.0"
                (version->string (package-version package)))

    (test-eq "package dependency"
             dependency
             (car (package-dependencies package)))

    (test-equal "package without dependencies"
                '()
                (package-dependencies
                  (make-package
                    "empty"
                    (string->version "1.0")
                    "./sources/empty"
                    '())))

    (test-error "reject string version"
                #t
                (make-package
                  "invalid"
                  "1.0"
                  "./sources/invalid"
                  '()))

    (test-error "reject non-dependency elements"
                #t
                (make-package
                  "invalid"
                  (string->version "1.0")
                  "./sources/invalid"
                  (list "hello")))

    (test-error "reject non-list dependencies"
                #t
                (make-package
                  "invalid"
                  (string->version "1.0")
                  "./sources/invalid"
                  'invalid))

    (test-error "reject improper dependency lists"
                #t
                (make-package
                  "invalid"
                  (string->version "1.0")
                  "./sources/invalid"
                  (cons dependency 'invalid)))

    (test-end "package")))
