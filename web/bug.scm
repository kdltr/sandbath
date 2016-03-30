(define (bug-page bug)
  (let ((ref (cut alist-ref <> bug)))
    (parameterize
        ((title (list "Bug #" (ref 'id) " - " (ref 'title)))
         (contents
          `(div
            (ul
             (li "Reported by: " ,(ref 'author))
             (li "Report date: " ,(ref 'date))
             (li "Status: " ,(latest-status (ref 'id)))
             ,(describe-scores (ref 'id)))
            (div
             ,(status-history (ref 'id))))))
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

(define (status-history id)
  (map
   (lambda (p)
     `(p "Status changed on " ,(alist-ref 'date p) " to " (em ,(alist-ref 'status p))))
   (statuses id)))
