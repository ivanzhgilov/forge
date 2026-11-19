(define-module (forge version types)
  #:use-module (srfi srfi-9)
  #:use-module (srfi srfi-13)
  #:export (version?
             version-constraint?
             string->version
             version->string
             version-compare
             version-exactly
             version-at-least
             version-at-most
             version-range
             any-version
             version-satisfies?))

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

(define (parse-version-components version)
  (unless (string? version)
    (error "version must be a string" version))

  (let loop ((chars (string->list version))
             (component 0)
             (has-digit? #f)
             (components '()))
    (cond
      ((null? chars)
       (if has-digit?
         (reverse (cons component components))
         (error "invalid version" version)))

      (else
        (let ((char (car chars)))
          (cond
            ((and (char>=? char #\0)
                  (char<=? char #\9))
             (loop
               (cdr chars)
               (+ (* component 10)
                  (- (char->integer char)
                     (char->integer #\0)))
               #t
               components))

            ((char=? char #\.)
             (if has-digit?
               (loop
                 (cdr chars)
                 0
                 #f
                 (cons component components))
               (error "invalid version" version)))

            (else
              (error "invalid version" version))))))))

(define (ensure-version version)
  (unless (version? version)
    (error "expected a version object" version)))

(define (string->version version)
  (%make-version (parse-version-components version)))

(define (version->string version)
  (ensure-version version)
  (string-join
    (map number->string (version-components version))
    "."))

(define (compare-components left right)
  (let loop ((left left)
             (right right))
    (if (and (null? left) (null? right))
      0
      (let ((a (if (null? left) 0 (car left)))
            (b (if (null? right) 0 (car right))))
        (cond
          ((< a b) -1)
          ((> a b) 1)
          (else
            (loop
              (if (null? left) '() (cdr left))
              (if (null? right) '() (cdr right)))))))))

(define (version-compare left right)
  (ensure-version left)
  (ensure-version right)

  (compare-components
    (version-components left)
    (version-components right)))

(define (version-exactly version)
  (ensure-version version)

  (%make-version-constraint
    version #t
    version #t))

(define (version-at-least version)
  (ensure-version version)

  (%make-version-constraint
    version #t
    #f #f))

(define (version-at-most version)
  (ensure-version version)

  (%make-version-constraint
    #f #f
    version #t))

(define (version-range lower lower-inclusive?
                       upper upper-inclusive?)
  (unless (boolean? lower-inclusive?)
    (error "lower-inclusive? must be a boolean"))

  (unless (boolean? upper-inclusive?)
    (error "upper-inclusive? must be a boolean"))

  (ensure-version lower)
  (ensure-version upper)

  (let ((comparison (version-compare lower upper)))
    (when (or (> comparison 0)
              (and (= comparison 0)
                   (not (and lower-inclusive? upper-inclusive?))))
      (error "invalid or empty version range" lower upper)))

  (%make-version-constraint
    lower lower-inclusive?
    upper upper-inclusive?))

(define (any-version)
  (%make-version-constraint #f #f #f #f))

(define (satisfies-lower-bound? candidate constraint)
  (let ((lower (constraint-lower-version constraint)))
    (or
      (not lower)
      (let ((comparison (version-compare candidate lower)))
        (or (> comparison 0)
            (and (= comparison 0)
                 (constraint-lower-inclusive? constraint)))))))

(define (satisfies-upper-bound? candidate constraint)
  (let ((upper (constraint-upper-version constraint)))
    (or
      (not upper)
      (let ((comparison (version-compare candidate upper)))
        (or (< comparison 0)
            (and (= comparison 0)
                 (constraint-upper-inclusive? constraint)))))))

(define (version-satisfies? version constraint)
  (ensure-version version)

  (unless (version-constraint? constraint)
    (error "expected a version constraint" constraint))

  (and
    (satisfies-lower-bound? version constraint)
    (satisfies-upper-bound? version constraint)))
