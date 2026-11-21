(define-module (forge package loader)
  #:use-module ((forge package types) #:prefix types:)
  #:use-module (srfi srfi-1)
  #:export (load-package-recipe))

(define (load-recipe-module path)
  (save-module-excursion
    (lambda ()
      (let ((loader-module (current-module)))
        (primitive-load path)

        (let ((recipe-module (current-module)))
          (when (eq? loader-module recipe-module)
            (error "package recipe must define a module" path))

          recipe-module)))))

(define (load-package-recipe path)
  (unless (string? path)
    (error "package recipe path must be a string" path))

  (let* ((recipe-module (load-recipe-module path))
         (interface (module-public-interface recipe-module)))

    (unless (module-defined? interface 'packages)
      (error "package recipe must export packages" path))

    (let ((packages (module-ref interface 'packages)))
      (unless (list? packages)
        (error "package recipe must export a list of packages"
               path
               packages))

      (unless (every types:package? packages)
        (error "package recipe contains an invalid package"
               path
               packages))

      packages)))
