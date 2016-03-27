(use spiffy sxml-transforms intarweb)

(define conversion-rules
  universal-conversion-rules)

(define conversion-rules
  (append `((*PI* *preorder*
                  . ,(lambda (PI tag . attrs)
                       (list #\< #\? tag
                             (map (lambda (p) (list #\space (car p) "=\"" (cdr p) "\"")) attrs)
                             #\? #\> #\newline))))
          universal-conversion-rules))

(define (list-page)
  `((*PI* xml (version "1.0") (encoding "utf-8"))
    (*PI* xml-stylesheet (type "text/css") (href "/style.css"))
    (html (@ (xmlns "http://www.w3.org/1999/xhtml"))
     (head (title "List of bugs"))
     (body
      (table
       (thead
        (tr
         (th (@ (scope col)) "Pain")
         (th (@ (scope col)) "Bug #")
         (th (@ (scope col)) "Title")
         (th (@ (scope col)) "Status")))
       (tbody
        ,@(list-entries))
       )))))

(define (list-entries)
  (map format-row (list-bugs)))

(define (format-row r)
  `(tr
    (td (@ (class pain)) ,(alist-ref 'score r))
    (td (@ (class bug-id)) ,(alist-ref 'id r))
    (td (@ (class title)) ,(alist-ref 'title r))
    (td (@ (class status)) "Open")))

(define (output-html sxml)
  (with-output-to-string
   (lambda ()
     (SRV:send-reply (pre-post-order sxml conversion-rules)))))

(vhost-map
 `(((: (* any)) .
    ,(lambda (continue)
       (send-response
        headers: '((content-type application/xhtml+xml))
        body: (output-html (list-page)))))))
