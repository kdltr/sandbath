(define (initialize-sessions)
  (exec (sql (accounts-database)
             "create table sessions (id text primary key not null,
                                     account text not null,
                                     last_seen datetime default CURRENT_TIMESTAMP) without rowid;")))

(define (insert-session session-id name)
  (exec (sql (accounts-database)
             "insert into sessions (id, account) values (?, ?);")
        session-id name))

(define (session session-id)
  (let ((res (query
              fetch-alist
              (sql (accounts-database)
                   "select * from sessions where id = ?;")
              session-id)))
    (and (not (null? res)) res)))

(define (remove-session session-id)
  (exec (sql (accounts-database)
             "delete from sessions where id = ?;")
        session-id))
