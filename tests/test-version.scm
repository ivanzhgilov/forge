(define-module (tests test-version)
  #:use-module (srfi srfi-64)
  #:use-module (forge version)
  #:export (run-tests))

(define (v value)
  (string->version value))

(define (run-tests)
  (test-begin "version")

  (test-assert "parsed value is a version"
               (version? (v "1.2.3")))

  (test-equal "version formatting"
              "1.2.3"
              (version->string (v "1.2.3")))

  (test-equal "version formatting preserves component count"
              "1.2.0"
              (version->string (v "1.2.0")))

  (test-equal "leading zero components are normalized"
              "1.2"
              (version->string (v "01.02")))

  (test-error "reject non-string version"
              #t
              (string->version 123))

  (test-error "reject empty version"
              #t
              (string->version ""))

  (test-error "reject invalid version"
              #t
              (string->version "1..2"))

  (test-error "reject version formatting of non-version"
              #t
              (version->string "1.2"))

  (test-equal "lower version"
              -1
              (version-compare (v "1.0") (v "2.0")))

  (test-equal "greater version"
              1
              (version-compare (v "2.0") (v "1.0")))

  (test-equal "equal versions"
              0
              (version-compare (v "1.5") (v "1.5")))

  (test-equal "numeric component comparison"
              1
              (version-compare (v "1.10") (v "1.9")))

  (test-equal "trailing zero components"
              0
              (version-compare (v "1.2") (v "1.2.0")))

  (test-error "version comparison requires version objects"
              #t
              (version-compare "1.0" (v "2.0")))

  (test-error "version-at-least requires a version object"
              #t
              (version-at-least "1.0"))

  (test-equal "exact version matches"
              #t
              (version-satisfies?
                (v "1.5.0")
                (version-exactly (v "1.5"))))

  (test-equal "exact version does not match"
              #f
              (version-satisfies?
                (v "1.6.0")
                (version-exactly (v "1.5"))))

  (test-equal "minimum version includes boundary"
              #t
              (version-satisfies?
                (v "1.5")
                (version-at-least (v "1.5"))))

  (test-equal "minimum version rejects lower version"
              #f
              (version-satisfies?
                (v "1.4")
                (version-at-least (v "1.5"))))

  (test-equal "maximum version includes boundary"
              #t
              (version-satisfies?
                (v "2.0")
                (version-at-most (v "2.0"))))

  (test-equal "maximum version rejects higher version"
              #f
              (version-satisfies?
                (v "2.1")
                (version-at-most (v "2.0"))))

  (test-equal "range includes lower boundary"
              #t
              (version-satisfies?
                (v "1.2.0")
                (version-range (v "1.2.0") #t
                               (v "2.0.0") #f)))

  (test-equal "range accepts intermediate version"
              #t
              (version-satisfies?
                (v "1.5.0")
                (version-range (v "1.2.0") #t
                               (v "2.0.0") #f)))

  (test-equal "range excludes upper boundary"
              #f
              (version-satisfies?
                (v "2.0.0")
                (version-range (v "1.2.0") #t
                               (v "2.0.0") #f)))

  (test-error "reject reversed version range"
              #t
              (version-range (v "2.0") #t
                             (v "1.0") #t))

  (test-error "reject empty version range"
              #t
              (version-range (v "1.0") #t
                             (v "1.0") #f))

  (test-equal "any version accepts arbitrary version"
              #t
              (version-satisfies? (v "100.0") (any-version)))

  (test-error "version-satisfies? requires a version object"
              #t
              (version-satisfies? "1.0" (any-version)))

  (test-error "version-satisfies? requires a constraint"
              #t
              (version-satisfies? (v "1.0") 'invalid))

  (test-end "version"))
