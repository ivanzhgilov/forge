(define-module (forge version)
  #:use-module ((forge version types) #:prefix types:)
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

(define version? types:version?)
(define version-constraint? types:version-constraint?)
(define string->version types:string->version)
(define version->string types:version->string)
(define version-compare types:version-compare)
(define version-exactly types:version-exactly)
(define version-at-least types:version-at-least)
(define version-at-most types:version-at-most)
(define version-range types:version-range)
(define any-version types:any-version)
(define version-satisfies? types:version-satisfies?)
