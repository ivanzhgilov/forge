(define-module (forge package)
  #:use-module ((forge package types) #:prefix types:)
  #:use-module ((forge package scanner) #:prefix scanner:)
  #:use-module ((forge package loader) #:prefix loader:)
  #:export (make-package
             package?
             package-name
             package-version
             package-source
             package-dependencies
             scan-package-recipes
             load-package-recipe))

(define make-package types:make-package)
(define package? types:package?)
(define package-name types:package-name)
(define package-version types:package-version)
(define package-source types:package-source)
(define package-dependencies types:package-dependencies)

(define scan-package-recipes scanner:scan-package-recipes)

(define load-package-recipe loader:load-package-recipe)
