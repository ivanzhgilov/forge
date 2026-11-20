(define-module (tests test-package-loader)
  #:use-module (srfi srfi-1)
  #:use-module (srfi srfi-64)
  #:use-module (forge package)
  #:use-module (forge version)
  #:export (run-tests))

(define (fixture path)
  (string-append
    "tests/fixtures/package-recipes/"
    path))

(define (run-tests)
  (test-begin "package loader")

  (let ((packages
          (load-package-recipe
            (fixture "core/system.scm"))))

    (test-equal "load multiple packages"
                2
                (length packages))

    (test-equal "load package names"
                '("hello" "hello-tools")
                (map package-name packages))

    (test-equal "load package versions"
                '("1.0" "2.0")
                (map
                  (lambda (package)
                    (version->string
                      (package-version package)))
                  packages))

    (test-assert "loaded values are package objects"
                 (every package? packages)))

  (let ((packages
          (load-package-recipe
            (fixture "development/compiler.scm"))))

    (test-equal "load single package"
                1
                (length packages))

    (test-equal "load package from nested directory"
                "compiler"
                (package-name (car packages))))

  (let ((module-before (current-module)))
    (load-package-recipe
      (fixture "core/system.scm"))

    (test-eq "restore current module after loading"
             module-before
             (current-module)))

  (test-error "reject missing exported packages"
              #t
              (load-package-recipe
                (fixture "invalid/missing-export.scm")))

  (test-error "reject non-list packages"
              #t
              (load-package-recipe
                (fixture "invalid/non-list.scm")))

  (test-error "reject invalid package elements"
              #t
              (load-package-recipe
                (fixture "invalid/invalid-element.scm")))

  (test-error "reject improper package lists"
              #t
              (load-package-recipe
                (fixture "invalid/improper-list.scm")))

  (test-error "reject recipe without module"
              #t
              (load-package-recipe
                (fixture "invalid/no-module.scm")))

  (test-error "reject missing recipe file"
              #t
              (load-package-recipe
                (fixture "missing.scm")))

  (test-error "reject non-string recipe path"
              #t
              (load-package-recipe 123))

  (test-end "package loader"))
