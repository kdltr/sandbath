(use spiffy sxml-transforms intarweb)

(include "web/list.scm")

(define title (make-parameter ""))
(define contents (make-parameter '()))

(define (page-template)
  `((*PI* xml (version "1.0") (encoding "utf-8"))
    (*PI* xml-stylesheet (type "text/css") (href "/style.css"))
    (html (@ (xmlns "http://www.w3.org/1999/xhtml"))
          (head (title ,(title)))
          (body
           ,(contents)))))

(define conversion-rules
  (append `((*PI* *preorder*
                  . ,(lambda (PI tag . attrs)
                       (list #\< #\? tag
                             (map (lambda (p) (list #\space (car p) "=\"" (cdr p) "\"")) attrs)
                             #\? #\> #\newline))))
          universal-conversion-rules))

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
