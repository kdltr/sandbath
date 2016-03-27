;; table accounts
;; - name
;; - password

(define (initialize-accounts)
  (exec (sql (accounts-database)
             "create table accounts (name text primary key not null,
                                     password text not null) without rowid;")))

(define (create-account name password)
  (exec
   (sql (accounts-database) "insert into accounts (name, password) values (?, ?);")
   name
   password))

(define (password name)
  (query
   fetch-value
   (sql (accounts-database) "select password from accounts where name = ?;")
   name))
