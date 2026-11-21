(define-module (tests test-package-catalog-loading)
  #:use-module (srfi srfi-64)
  #:use-module (forge package)
  #:use-module (forge version)
  #:export (run-tests))

(define (fixture path)
  (string-append
    "tests/fixtures/package-recipes/"
    path))

(define (catalog-fixture path)
  (string-append
    "tests/fixtures/package-catalog/"
    path))

(define (package-versions catalog name)
  (map
    (lambda (package)
      (version->string
        (package-version package)))
    (package-catalog-find catalog name)))

(define (run-tests)
  (test-begin "package catalog loading")

  (let ((catalog
          (load-package-catalog
            (fixture "valid"))))

    (test-assert "return package catalog"
                 (package-catalog? catalog))

    (test-equal "load packages from first recipe"
                '("1.0")
                (package-versions catalog "hello"))

    (test-equal "load multiple packages from one recipe"
                '("2.0")
                (package-versions catalog "hello-tools"))

    (test-equal "load package from nested recipe"
                '("1.5")
                (package-versions catalog "compiler")))

  (let ((catalog
          (load-package-catalog
            (fixture "empty"))))

    (test-assert "return empty package catalog"
                 (package-catalog? catalog))

    (test-equal "empty catalog contains no packages"
                '()
                (package-catalog-find catalog "hello")))

  (test-error "reject invalid package recipes"
              #t
              (load-package-catalog
                (fixture "invalid")))
  (test-error "reject duplicate packages across recipes"
              #t
              (load-package-catalog
                (catalog-fixture "duplicates")))

  (test-end "package catalog loading"))

