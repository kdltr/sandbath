(use srfi-1 sql-de-lite)

(database (open-database (database-file)))
(accounts-database (open-database (accounts-file)))

(define max-score
  (fold
   (lambda (type acc) (* acc (length (cadr type))))
   1
   (score-types)))

(define (initialize)
  (initialize-accounts)
  (initialize-scores)
  (initialize-bugs))

(include "db/accounts.scm")
(include "db/bugs.scm")
(include "db/scores.scm")
(include "db/statuses.scm")

(define (all-bugs-with-score)
  (map
   (lambda (b)
     (alist-cons 'score (total-score (alist-ref 'id b)) b))
   (all-bugs)))

(define (list-bugs)
  (sort (all-bugs-with-score)
        (lambda (b1 b2) (> (alist-ref 'score b1) (alist-ref 'score b2)))))
