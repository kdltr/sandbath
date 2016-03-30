;; table statuses
;; - id
;; - bug_id (bugs.id)
;; - author (accounts.name)
;; - date
;; - status

(define (initialize-statuses)
  (exec (sql (database)
             "create table statuses (id integer primary key asc autoincrement,
                                     bug_id integer,
                                     author text,
                                     date datetime default CURRENT_TIMESTAMP,
                                     status text,
                                     foreign key (bug_id) references bugs (id));")))

(define (insert-status bug-id text)
  (exec
   (sql (database) "insert into statuses (bug_id, status) values (?, ?);")
   bug-id text))

(define (statuses bug-id)
  (query
   fetch-alists
   (sql (database) "select date, status from statuses where bug_id = ? order by id asc;")
   bug-id))

(define (latest-status bug-id)
  (query
   fetch-value
   (sql (database) "select status from statuses where bug_id = ? order by id desc limit 1;")
   bug-id))
