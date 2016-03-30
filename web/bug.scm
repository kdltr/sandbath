(define (bug-page bug)
  (let ((ref (cut alist-ref <> bug)))
    (parameterize
        ((title (list "Bug #" (ref 'id) " - " (ref 'title)))
         (contents
          `(ul
            (li "Reported by: " ,(ref 'author))
            (li "Report date: " ,(ref 'date))
            ,(describe-scores (ref 'id)))))
      (page-template))))

(define (score-description type score)
  (list-ref
   (car (alist-ref type (score-types) string=?))
   (sub1 score)))

(define (describe-scores bug-id)
  (map
   (lambda (t)
     (let ((type-name (car t)))
      `(li ,type-name ": " ,(score-description type-name (score bug-id type-name)))))
   (score-types)))
