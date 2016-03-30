(define (list-page)
  (parameterize
      ((title "List of bugs")
       (contents
        `(table
          (thead
           (tr
            (th (@ (scope col)) "Pain")
            (th (@ (scope col)) "Bug #")
            (th (@ (scope col)) "Title")
            (th (@ (scope col)) "Status")))
          (tbody
           ,@(list-entries))
          )))
    (page-template)
    ))

(define (list-entries)
  (map format-row (list-bugs)))

(define (format-row r)
  `(tr
    (td (@ (class pain)) ,(alist-ref 'score r))
    (td (@ (class bug-id)) ,(alist-ref 'id r))
    (td (@ (class title)) ,(alist-ref 'title r))
    (td (@ (class status)) "Open")))
