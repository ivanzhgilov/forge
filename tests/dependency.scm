(use-modules (srfi srfi-64)
             (forge dependency)
             (forge version))

(test-begin "forge-dependency")

(define runner (test-runner-current))

(define runtime-dependency
  (make-dependency
    "hello"
    (version-range "1.0.0" #t "2.0.0" #f)
    'runtime))

(define build-dependency
  (make-dependency
    "gcc"
    (version-at-least "13.0")
    'build))

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
    "1.5.0"
    (dependency-constraint runtime-dependency)))

(test-assert "version does not satisfy dependency constraint"
  (not
    (version-satisfies?
      "2.0.0"
      (dependency-constraint runtime-dependency))))

(test-assert "build dependency accepts newer version"
  (version-satisfies?
    "13.2.1"
    (dependency-constraint build-dependency)))

(test-end "forge-dependency")

(exit
  (if (and
        (zero? (test-runner-fail-count runner))
        (zero? (test-runner-xpass-count runner)))
      0
      1))
