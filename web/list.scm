(define (list-page bugs)
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
           ,@(list-entries bugs))
          )))
    (page-template)
    ))

(define (list-entries bugs)
  (map format-row bugs))

(define (format-row bug)
  (let* ((ref (cut alist-ref <> bug))
         (bug-link (lambda (text) `(a (@ (href (,(ref 'id) ".xhtml"))) ,text))))
    `(tr
      (td (@ (class pain)) ,(ref 'score))
      (td (@ (class bug-id)) ,(bug-link (ref 'id)))
      (td (@ (class title)) ,(bug-link (ref 'title)))
      (td (@ (class status)) "Open"))))
