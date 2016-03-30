(use crypt)

(define database-file
  (make-parameter #f))

(define accounts-file
  (make-parameter #f))

(define database
  (make-parameter #f))

(define accounts-database
  (make-parameter #f))

(define score-types
  (make-parameter '()))

(load "config")

(load "db.scm")
(load "web.scm")

(define (fake-bug n)
  (let ((bug-id (create-bug "Kooda" (sprintf "Fake bug ~A" n))))
    (with-transaction (database)
      (lambda ()
        (insert-score bug-id "type" (add1 (random 7)))
        (insert-score bug-id "priority" (add1 (random 5)))
        (insert-score bug-id "likelihood" (add1 (random 5)))))))

(define (write-page file page)
  (with-output-to-file file
    (lambda ()
      (display (output-html page)))))

(define (generate-all-pages)
  (let ((bugs (list-bugs)))
    (write-page "index.xhtml" (list-page bugs))
    (for-each
     (lambda (bug)
       (write-page
        (string-append (number->string (alist-ref 'id bug)) ".xhtml")
        (bug-page bug)))
     bugs)))
