;; parse a list is read
;; the type of list:
;;   !   head
;;   =@  rank
;;   $   style
;;   +@  node
;;   ->  line
(define (lsgv-parse content)
  (if (list? content)
      (let* ((op (car content))
             (content (cdr content)))
        (cond
         ((equal? op '$) (lsgv-parse-face content))
         ((equal? op '+@) (lsgv-parse-node content))
         ((equal? op '!) (lsgv-parse-head content))
         ((equal? op '=@) (lsgv-parse-rank content))
         ((or (equal? op '->)
              (equal? op '<-))
          (lsgv-parse-line content))))))

;; head parser
;; 1. print rankdir, layout, sep, splines
;; 2. set rainbow count, rainbow color
(define (lsgv-parse-head content)
  (let fn ((attributes content))
    (unless (null? attributes)
      (put-hash-table! head-container (car attributes) (cadr attributes))
      (fn (cddr attributes))))
  ;; rainbow section
  (let ((color (get-hash-table head-container ':rainbow-color '()))
        (count (get-hash-table head-container ':rainbow-count '())))
    (unless (null? color) (set! rainbow-color color))
    (unless (null? count) (set! rainbow-count count)))
  ;; rankdir layout sep splines
  (let ((rankdir (get-hash-table head-container ':rankdir "TB"))
        (layout (get-hash-table head-container ':layout "dot"))
        (sep (get-hash-table head-container ':sep ""))
        (splines (get-hash-table head-container ':splines "curved")))
    (display (format "  graph [rankdir = ~s];~%  layout = ~s;~%  sep = ~s;~%  splines = ~s;~%" rankdir layout sep splines))))

;; rank parser, print rank section
(define (lsgv-parse-rank content)
  (display "  {\n")
  (display "    rank = same;\n")
  (for-each (lambda (i) (display (format "    \"~s\";~%" i))) content)
  (display "  }\n"))

;; style parser
;; put the style attribute to the container
;; for example:
;;   (style1 :key value) => face-container %(style1 %(:key value))
(define (lsgv-parse-face content)
  (let ((name (car content))
        (ht (make-hash-table)))
    (let fn ((attributes (cdr content)))
      (unless (null? attributes)
        (put-hash-table! ht (car attributes) (cadr attributes))
        (fn (cddr attributes))))
    (put-hash-table! face-container name ht)))

;; data parser
;; 1. parse attribute(start with #\:)
;; 2. parse data
;; for example:
;;   (:k v d1 d2) ->
;;                      entry %(:k v)
;;                      data '(d1 d2)
(define (lsgv-parse-data content generate-fn)
  (let ((entry (make-hash-table))
        (data '()))
    (let fn ((elements content))
      (unless (null? elements)
        (let ((element (car elements)))
          (if (and
               (symbol? element)
               (equal? (string-ref (symbol->string element) 0) #\:))
              (begin
                ;; entry
                (put-hash-table! entry element (cadr elements))
                (fn (cddr elements)))
              (begin
                ;; data
                (set! data (append data (list element)))
                (fn (cdr elements)))))))
    ;; proccess type attribute
    (let ((type (get-hash-table entry ':type '())))
      (if (null? type)
          #f
          (set! entry (merge-hash-table (get-hash-table face-container type '()) entry))))
    ;; process entry & data
    (generate-fn entry data)))

(define (lsgv-parse-node content)
  (lsgv-parse-data content generate-node-fn))

(define (lsgv-parse-line content)
  (lsgv-parse-data content generate-line-fn))

;; generate node, including dynamic calculate
(define (generate-node-fn entry data)
  (for-each
   (lambda (node)
     (if (symbol? node)
         (set! node (list node (symbol->string node))))
     ;; color override, dymaic calculating
     (refresh-face-color entry)
     (let ((name (car node))
           (label (cadr node))
           (color (get-face-color entry))
           (fontcolor (get-face-fontcolor entry))
           (style (get-face-style entry))
           (shape (get-face-shape entry)))
       (let ((l (string-length color)))
         ;; record the node color
         (put-hash-table! node-color-container name (substring color (- l 7) l)))
       (print-node name label shape style color fontcolor)))
   data))

;; genearte line, including dynamic calculate
(define (generate-line-fn entry data)
  (let fn ((from (car data))
           (to (cadr data)))
    (if (list? to)
        (let ((prev-i (car to)))
          (for-each
           (lambda (i)
             (if (list? i)
                 (fn prev-i i)
                 (fn from i))
             (set! prev-i i))
           to))
        (let ((style (get-face-style entry))
              (arrowhead (get-face-arrowhead entry))
              (penwidth (get-face-penwidth entry))
              (label (get-face-label entry))
              (color (get-face-color entry))
              (relation (get-hash-table entry ':relation '())))
          ;; dynamic calculate
          (unless (null? relation)
            (cond ((equal? relation 'parent)
                   (set! color (get-hash-table node-color-container from default-face-color-rgb)))
                  ((equal? relation 'child)
                   (set! color (get-hash-table node-color-container to default-face-color-rgb)))))
          (print-line from to label color style penwidth arrowhead)))))

(define (print-node name label shape style color fontcolor)
  (display (format "  \"~s\" [label = ~s, shape = ~s, style = ~s, color = ~s, fontcolor = ~s];~%" name label shape style color fontcolor)))

(define (print-line from to label color style penwidth arrowhead)
  (display (format "  \"~s\" -> \"~s\" [label = ~s, fontcolor = ~s, color = ~s, style = ~s, penwidth = ~s, arrowhead = ~s];~%" from to label color color style penwidth arrowhead)))

;; color override, dynamic calculate color, filled-color, fontcolor
;; for example:
;;   ($ :override (rainbow)) -> color
;;   ($ :color-ratio 1.2) -> color
;;   ($ :filled-color-ratio 1.3) -> filled-color
;;   ($ :fontcolor-ratio 1.4) -> fontcolor
(define (refresh-face-color entry)
  (let ((override (get-hash-table entry ':override '()))
        (rainbow-fontcolor (get-hash-table entry ':rainbow-fontcolor '()))
        (fontcolor-offset (get-hash-table entry ':fontcolor-offset '()))
        (filled-color-offset (get-hash-table entry ':filled-color-offset '()))
        (color-offset (get-hash-table entry ':color-offset '()))
        (fontcolor-ratio (get-hash-table entry ':fontcolor-ratio '()))
        (filled-color-ratio (get-hash-table entry ':filled-color-ratio '()))
        (color-ratio (get-hash-table entry ':color-ratio '())))
    (if (memq 'rainbow-color override)
        (put-hash-table! entry ':color (calc-rainbow)))
    (for-each
     (lambda (pair)
       (let ((k (car pair))
             (v (cdr pair)))
         (unless (null? v)
           (put-hash-table! entry k (calc-ratio-color v (get-hash-table entry ':color #x000000))))))
     (list (cons ':fontcolor fontcolor-ratio)
           (cons ':filled-color filled-color-ratio)
           (cons ':color color-ratio)))
    (for-each
     (lambda (pair)
       (let ((k (car pair))
             (v (cdr pair)))
         (unless (null? v)
           (put-hash-table! entry k (calc-offset-color v (get-hash-table entry ':color #x000000))))))
     (list (cons ':fontcolor fontcolor-offset)
           (cons ':filled-color filled-color-offset)
           (cons ':color color-offset)))
    ))

;; get color string
;; 1. "#336699"
;; 2. "#336699:#445566"
(define (get-face-color entry)
  (let ((face-color (get-hash-table entry ':color '()))
        (face-filled-color (get-hash-table entry ':filled-color '())))
    (if (null? face-color)
        default-face-color-rgb
        (if (null? face-filled-color)
            (convert-rgb face-color)
            (string-append (convert-rgb face-filled-color) ":" (convert-rgb face-color))))))

(define (get-face-fontcolor entry)
  (let ((face-fontcolor (get-hash-table entry ':fontcolor '())))
    (if (null? face-fontcolor)
        default-face-fontcolor-rgb
        (convert-rgb face-fontcolor))))

(define (get-face-style entry)
  (let ((face-style (get-hash-table entry ':style '())))
    (if (null? face-style)
        default-face-style
        face-style)))

(define (get-face-shape entry)
  (let ((face-shape (get-hash-table entry ':shape '())))
    (if (null? face-shape)
        default-face-shepe
        face-shape)))

(define (get-face-penwidth entry)
  (let ((face-penwidth (get-hash-table entry ':penwidth '())))
    (if (null? face-penwidth)
        default-face-penwidth
        face-penwidth)))

(define (get-face-arrowhead entry)
  (let ((face-arrowhead (get-hash-table entry ':arrowhead '())))
    (if (null? face-arrowhead)
        default-face-arrowhead
        face-arrowhead)))

(define (get-face-label entry)
  (let ((face-label (get-hash-table entry ':label '())))
    (if (null? face-label)
        ""
        face-label)))
