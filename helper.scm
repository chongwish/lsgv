(define (merge-hash-table ht1 ht2)
  (if (null? ht1)
      ht2
      (let ((ht (make-hash-table)))
        (hash-table-for-each ht1 (lambda (k v) (put-hash-table! ht k v)))
        (hash-table-for-each ht2 (lambda (k v) (put-hash-table! ht k v)))
        ht)))

;; number to rgb
;; 3 => "#000003"
(define (convert-rgb number)
  (let* ((s (string-append "000000" (number->string number 16)))
         (l (string-length s)))
    (string-append "#" (substring s (- l 6) l))))

;; split color to rgb vector
;; #x009060 => '#(00 #x90 #x60)
(define (split-color color)
  (let ((red (div (logand #xff0000 color) #x010000))
        (green (div (logand #x00ff00 color) #x000100))
        (blue (logand #x0000ff color)))
    (vector red green blue)))

;; get the max number index of vecotr
;; '#(00 #x90 #x60) => 2
(define (calc-current-index color)
  (let ((red (vector-ref color 0))
        (green (vector-ref color 1))
        (blue (vector-ref color 2)))
    (cond ((and (> red green) (> red blue)) 0)
          ((and (> green red) (> green blue)) 1)
          (else 2))))

;; #x90 18 => #x30
(define (calc-color-step main-color count)
  (div main-color (div count 6)))

(define (calc-next-index n)
  (mod (+ n 1) 3))

;; #(00 #x90 #x60) => #x009060
(define (merge-color color)
  (+ (* #x010000 (vector-ref color 0))
     (* #x000100 (vector-ref color 1))
     (vector-ref color 2)))

;; dynamic calculate rainbow color
;; define a init color, for example green
;;   green -> aqua -> blue -> purple -> red -> yellow -> ...
;; like a color circle selector:
;;   color green +    green -    blue +     blue -     red +      red -
;;         00 90 00   00 90 90   00 00 90   90 00 90   90 00 00   90 90 00
;;         00 90 30   00 60 90   30 00 90   90 00 60   90 30 00   60 90 00
;;         00 90 60   00 30 90   60 00 90   90 00 30   90 60 00   30 90 00
;;   index (2 3)      (2 3)      (3 1)      (3 1)      (1 2)      (1 2)
;;   max   90
(define (calc-rainbow)
  (if (null? rainbow-color-container)
      (let* ((colors (split-color rainbow-color))
             (current-index (calc-current-index colors))
             (max-color (vector-ref colors current-index))
             (step (calc-color-step max-color rainbow-count)))
        (set! rainbow-color-container (vector current-index max-color step))))
  (let ((step (vector-ref rainbow-color-container 2))
        (max-color (vector-ref rainbow-color-container 1))
        (current-index (vector-ref rainbow-color-container 0))
        (colors (split-color rainbow-color))
        (next-index (calc-next-index (vector-ref rainbow-color-container 0))))
    (if (< (vector-ref colors next-index) max-color)
        (vector-set! colors next-index (+ step (vector-ref colors next-index)))
        (let ((current-value (- (vector-ref colors current-index) step)))
          (if (> current-value 0)
              (vector-set! colors current-index current-value)
              (begin
                (vector-set! colors current-index 0)
                (vector-set! rainbow-color-container 0 next-index)))))
    (set! rainbow-color (merge-color colors))
    rainbow-color))

;; #(0 90 60) 0.5 => #(0 45 30)
(define (calc-ratio-color ratio color)
  (let ((colors (split-color color)))
    (merge-color
     (vector-map
      (lambda (n)
        (let ((result (exact (floor (* n ratio)))))
          (cond ((> result #xff) #xff)
                ((< result 0) 0)
                (else result))))
      colors))))
