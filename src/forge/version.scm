(define-module (forge version)
  #:use-module (srfi srfi-9)
  #:export (version-compare
            version-constraint?
            version-exactly
            version-at-least
            version-at-most
            version-range
            any-version
            version-satisfies?))

(define (parse-version version)
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
  (compare-components
    (parse-version left)
    (parse-version right)))

(define-record-type <version-constraint>
  (%make-version-constraint lower lower-inclusive?
                            upper upper-inclusive?)
  version-constraint?
  (lower constraint-lower)
  (lower-inclusive? constraint-lower-inclusive?)
  (upper constraint-upper)
  (upper-inclusive? constraint-upper-inclusive?))

(define (version-exactly version)
  (let ((components (parse-version version)))
    (%make-version-constraint
      components #t
      components #t)))

(define (version-at-least version)
  (%make-version-constraint
    (parse-version version) #t
    #f #f))

(define (version-at-most version)
  (%make-version-constraint
    #f #f
    (parse-version version) #t))

(define (version-range lower lower-inclusive?
                       upper upper-inclusive?)
  (unless (boolean? lower-inclusive?)
    (error "lower-inclusive? must be a boolean"))

  (unless (boolean? upper-inclusive?)
    (error "upper-inclusive? must be a boolean"))

  (let* ((lower-components (parse-version lower))
         (upper-components (parse-version upper))
         (comparison
          (compare-components lower-components upper-components)))

    (when (or (> comparison 0)
              (and (= comparison 0)
                   (not (and lower-inclusive? upper-inclusive?))))
      (error "invalid or empty version range" lower upper))

    (%make-version-constraint
      lower-components lower-inclusive?
      upper-components upper-inclusive?)))

(define (any-version)
  (%make-version-constraint #f #f #f #f))

(define (satisfies-lower-bound? candidate lower inclusive?)
  (or
    (not lower)
    (let ((comparison
           (compare-components candidate lower)))
      (or (> comparison 0)
          (and (= comparison 0) inclusive?)))))

(define (satisfies-upper-bound? candidate upper inclusive?)
  (or
    (not upper)
    (let ((comparison
           (compare-components candidate upper)))
      (or (< comparison 0)
          (and (= comparison 0) inclusive?)))))

(define (version-satisfies? version constraint)
  (unless (version-constraint? constraint)
    (error "expected a version constraint" constraint))

  (let ((candidate (parse-version version)))
    (and
      (satisfies-lower-bound?
        candidate
        (constraint-lower constraint)
        (constraint-lower-inclusive? constraint))

      (satisfies-upper-bound?
        candidate
        (constraint-upper constraint)
        (constraint-upper-inclusive? constraint)))))
