(import (scheme base)
        (scheme write)
        (scheme read)
        (scheme file)
        (scheme load)
        (scheme process-context)
        (srfi 69)
        (srfi 60)
        (srfi 28))

(define (put-hash-table! ht k v)
  (hash-table-set! ht k v))

(define (hash-table-for-each ht fn)
  (hash-table-walk ht fn))

(define (get-hash-table ht k d)
  (hash-table-ref/default ht k d))

(define (div x1 x2)
  (quotient x1 x2))

(define (mod x1 x2)
  (remainder x1 x2))
