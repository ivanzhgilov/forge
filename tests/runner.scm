(define-module (tests runner)
  #:use-module (ice-9 format)
  #:use-module (srfi srfi-13)
  #:use-module (srfi srfi-64)
  #:use-module (tests version)
  #:use-module (tests dependency)
  #:export (run-tests))

(define (result-label kind)
  (case kind
    ((pass) "PASS")
    ((fail) "FAIL")
    ((xfail) "XFAIL")
    ((xpass) "XPASS")
    ((skip) "SKIP")
    (else "UNKNOWN")))

(define (format-test-name runner)
  (string-join
    (append
      (test-runner-group-path runner)
      (list (test-runner-test-name runner)))
    " / "))

(define (write-test-result runner log-port)
  (let ((kind (test-result-kind runner)))
    (format log-port "[~a] ~a~%"
            (result-label kind)
            (format-test-name runner))

    (when (memq kind '(fail xpass))
      (format log-port "  ~s~%"
              (test-result-alist runner)))

    (force-output log-port)))

(define (write-summary port runner)
  (let* ((passed (test-runner-pass-count runner))
         (failed (test-runner-fail-count runner))
         (unexpected-passes (test-runner-xpass-count runner))
         (expected-failures (test-runner-xfail-count runner))
         (skipped (test-runner-skip-count runner))
         (total (+ passed
                   failed
                   unexpected-passes
                   expected-failures
                   skipped)))

    (format port "Total: ~a~%" total)
    (format port "Passed: ~a~%" passed)
    (format port "Failed: ~a~%" (+ failed unexpected-passes))
    (format port "Unexpected passes: ~a~%" unexpected-passes)
    (format port "Expected failures: ~a~%" expected-failures)
    (format port "Skipped: ~a~%" skipped)))

(define (write-terminal-summary port runner log-path)
  (let ((passed (test-runner-pass-count runner))
        (failed (+ (test-runner-fail-count runner)
                   (test-runner-xpass-count runner)))
        (expected-failures (test-runner-xfail-count runner))
        (skipped (test-runner-skip-count runner)))

    (format port
            "Tests: ~a | Passed: ~a | Failed: ~a | XFail: ~a | Skipped: ~a~%"
            (+ passed failed expected-failures skipped)
            passed
            failed
            expected-failures
            skipped)

    (format port "Log: ~a~%" log-path)))

(define (run-tests log-path)
  (let ((runner (test-runner-null))
        (log-port (open-output-file log-path)))

    (test-runner-on-test-end!
      runner
      (lambda (runner)
        (write-test-result runner log-port)))

    (dynamic-wind
      (lambda () #t)

      (lambda ()
        (format log-port "Forge test results~%~%")

        (test-with-runner runner
          (run-version-tests)
          (run-dependency-tests))

        (write-summary log-port runner)
        (force-output log-port)

        (write-terminal-summary
          (current-output-port)
          runner
          log-path)

        (if (or (> (test-runner-fail-count runner) 0)
                (> (test-runner-xpass-count runner) 0))
            1
            0))

      (lambda ()
        (close-port log-port)))))
