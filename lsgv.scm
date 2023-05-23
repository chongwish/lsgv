;; main

(include "data.scm")
(include "helper.scm")
(include "file.scm")
(include "parser.scm")
(include "style.scm")

(display "digraph G {\n")
(for-each (lambda (f) (lsgv-read-file f)) (cdr (command-line)))
(display "}\n")
