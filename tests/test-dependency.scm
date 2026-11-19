(define-module (tests test-dependency)
  #:use-module (srfi srfi-64)
  #:use-module (forge dependency)
  #:use-module (forge version)
  #:export (run-tests))

(define (run-tests)
  (let ((runtime-dependency
          (make-dependency
            "hello"
            (version-range
              (string->version "1.0.0") #t
              (string->version "2.0.0") #f)
            'runtime))
        (build-dependency
          (make-dependency
            "gcc"
            (version-at-least (string->version "13.0"))
            'build)))

    (test-begin "dependency")

    (test-assert "dependency type"
                 (dependency? runtime-dependency))

    (test-equal "dependency name"
                "hello"
                (dependency-name runtime-dependency))

    (test-eq "runtime dependency kind"
             'runtime
             (dependency-kind runtime-dependency))

    (test-eq "build dependency kind"
             'build
             (dependency-kind build-dependency))

    (test-assert "version satisfies dependency constraint"
                 (version-satisfies?
                   (string->version "1.5.0")
                   (dependency-constraint runtime-dependency)))

    (test-assert "version does not satisfy dependency constraint"
                 (not
                   (version-satisfies?
                     (string->version "2.0.0")
                     (dependency-constraint runtime-dependency))))

    (test-assert "build dependency accepts newer version"
                 (version-satisfies?
                   (string->version "13.2.1")
                   (dependency-constraint build-dependency)))

    (test-end "dependency")))
