(define-module (forge version types)
  #:use-module (srfi srfi-9)
  #:export (%make-version
             version?
             version-components
             %make-version-constraint
             version-constraint?
             constraint-lower-version
             constraint-lower-inclusive?
             constraint-upper-version
             constraint-upper-inclusive?))

(define-record-type <version>
  (%make-version components)
  version?
  (components version-components))

(define-record-type <version-constraint>
  (%make-version-constraint lower-version lower-inclusive?
                            upper-version upper-inclusive?)
  version-constraint?
  (lower-version constraint-lower-version)
  (lower-inclusive? constraint-lower-inclusive?)
  (upper-version constraint-upper-version)
  (upper-inclusive? constraint-upper-inclusive?))
