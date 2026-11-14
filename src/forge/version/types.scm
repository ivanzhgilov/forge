(define-module (forge version types)
  #:use-module (srfi srfi-9)
  #:export (%make-version
             version?
             version-components
             %make-version-constraint
             version-constraint?
             constraint-lower
             constraint-lower-inclusive?
             constraint-upper
             constraint-upper-inclusive?))

(define-record-type <version>
  (%make-version components)
  version?
  (components version-components))

(define-record-type <version-constraint>
  (%make-version-constraint lower lower-inclusive?
                            upper upper-inclusive?)
  version-constraint?
  (lower constraint-lower)
  (lower-inclusive? constraint-lower-inclusive?)
  (upper constraint-upper)
  (upper-inclusive? constraint-upper-inclusive?))
