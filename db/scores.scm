;; table scores
;; - id (bugs.id)
;; - type
;; - value

(define (initialize-scores)
  (exec (sql (database) "create table scores (bug_id integer,
                                              type text,
                                              value integer,
                                              foreign key (bug_id) references bugs (id));")))

(define (insert-score bug-id name value)
  (assert (member name (map car (score-types))))
  (exec (sql (database) "insert into scores (bug_id, type, value) values (?, ?, ?);")
        bug-id name value))

(define (total-score bug-id)
  (let* ((scores (query fetch-column (sql (database) "select value from scores where bug_id = ?")
                        bug-id))
         (raw-score (fold * 1 scores)))
    (inexact->exact (ceiling (* 100 (/ raw-score max-score))))))

