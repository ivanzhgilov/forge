(use-modules (tests runner))

(let ((arguments (cdr (command-line))))
  (when (> (length arguments) 1)
    (error "usage: tests/run.scm [log-file]"))

  (exit
    (run-tests
      (if (null? arguments)
          "logs/test.log"
          (car arguments)))))
