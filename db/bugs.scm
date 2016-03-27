;; table bugs
;; - id
;; - author (accounts.name)
;; - date
;; - title

(define (initialize-bugs)
  (exec (sql (database)
             "create table bugs (id integer primary key asc autoincrement,
                                 author text not null,
                                 date datetime default CURRENT_TIMESTAMP,
                                 title text not null,
                                 foreign key (author) references accounts (name));")))

(define (create-bug author title)
  (exec
   (sql (database) "insert into bugs (author, title) values (?, ?);")
   author title)
  (last-insert-rowid (database)))

(define (all-bugs)
  (query
   fetch-alists
   (sql (database) "select * from bugs;")))

(define (bug id)
  (query
   fetch-alist
   (sql (database) "select * from bugs where id = ?;")
   id))
