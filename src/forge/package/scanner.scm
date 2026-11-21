(define-module (forge package scanner)
  #:use-module (ice-9 ftw)
  #:use-module (srfi srfi-1)
  #:use-module (srfi srfi-13)
  #:export (scan-package-recipes))

(define (scan-package-recipes directory)
  (unless (string? directory)
    (error "package directory must be a string" directory))

  (unless (eq? (stat:type (lstat directory)) 'directory)
    (error "package path must be a directory" directory))

  (sort
    (file-system-fold
      (lambda (path stat result)
        (eq? (stat:type stat) 'directory))

      (lambda (path stat result)
        (if (and (eq? (stat:type stat) 'regular)
                 (string-suffix? ".scm" path))
          (cons path result)
          result))

      (lambda (path stat result)
        result)

      (lambda (path stat result)
        result)

      (lambda (path stat result)
        result)

      (lambda (path stat errno result)
        (error "unable to scan package directory"
               path
               errno))

      '()
      directory
      lstat)

    string<?))
