(define-module (forge package)
  #:use-module (srfi srfi-1)
  #:use-module ((forge package types) #:prefix types:)
  #:use-module ((forge package scanner) #:prefix scanner:)
  #:use-module ((forge package loader) #:prefix loader:)
  #:use-module ((forge package catalog) #:prefix catalog:)
  #:export (make-package
             package?
             package-name
             package-version
             package-source
             package-dependencies
             scan-package-recipes
             load-package-recipe
             make-package-catalog
             package-catalog?
             package-catalog-find
             load-package-catalog directory))

(define make-package types:make-package)
(define package? types:package?)
(define package-name types:package-name)
(define package-version types:package-version)
(define package-source types:package-source)
(define package-dependencies types:package-dependencies)

(define scan-package-recipes scanner:scan-package-recipes)

(define load-package-recipe loader:load-package-recipe)

(define make-package-catalog catalog:make-package-catalog)
(define package-catalog? catalog:package-catalog?)
(define package-catalog-find catalog:package-catalog-find)

(define (load-package-catalog directory)
  (let* ((recipe-paths (scan-package-recipes directory))
         (packages
           (append-map load-package-recipe recipe-paths)))
    (make-package-catalog packages)))
