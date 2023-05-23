;; read file && parse it
(define (lsgv-read-file file-name)
  (call-with-input-file file-name
    (lambda (port)
      (let fn ((content (read port)))
        (unless (eof-object? content)
          (lsgv-parse content)
          (fn (read port)))))))
