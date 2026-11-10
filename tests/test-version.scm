(define-module (tests test-version)
  #:use-module (srfi srfi-64)
  #:use-module (forge version)
  #:export (run-tests))

(define (run-tests)
  (test-begin "version")

  (test-equal "lower version"
              -1
              (version-compare "1.0" "2.0"))

  (test-equal "greater version"
              1
              (version-compare "2.0" "1.0"))

  (test-equal "equal versions"
              0
              (version-compare "1.5" "1.5"))

  (test-equal "numeric component comparison"
              1
              (version-compare "1.10" "1.9"))

  (test-equal "trailing zero components"
              0
              (version-compare "1.2" "1.2.0"))

  (test-equal "exact version matches"
              #t
              (version-satisfies? "1.5.0" (version-exactly "1.5")))

  (test-equal "exact version does not match"
              #f
              (version-satisfies? "1.6.0" (version-exactly "1.5")))

  (test-equal "minimum version includes boundary"
              #t
              (version-satisfies? "1.5" (version-at-least "1.5")))

  (test-equal "minimum version rejects lower version"
              #f
              (version-satisfies? "1.4" (version-at-least "1.5")))

  (test-equal "maximum version includes boundary"
              #t
              (version-satisfies? "2.0" (version-at-most "2.0")))

  (test-equal "maximum version rejects higher version"
              #f
              (version-satisfies? "2.1" (version-at-most "2.0")))

  (test-equal "range includes lower boundary"
              #t
              (version-satisfies?
                "1.2.0"
                (version-range "1.2.0" #t "2.0.0" #f)))

  (test-equal "range accepts intermediate version"
              #t
              (version-satisfies?
                "1.5.0"
                (version-range "1.2.0" #t "2.0.0" #f)))

  (test-equal "range excludes upper boundary"
              #f
              (version-satisfies?
                "2.0.0"
                (version-range "1.2.0" #t "2.0.0" #f)))

  (test-equal "any version accepts arbitrary version"
              #t
              (version-satisfies? "100.0" (any-version)))

  (test-end "version"))
