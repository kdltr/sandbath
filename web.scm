(use sxml-transforms)

(include "web/api-login.scm")
(include "web/list.scm")
(include "web/bug.scm")

(define title (make-parameter ""))
(define contents (make-parameter '()))

(define (page-template)
  `((*PI* xml (version "1.0") (encoding "utf-8"))
    (*PI* xml-stylesheet (type "text/css") (href "/style.css"))
    (doctype)
    (html (@ (xmlns "http://www.w3.org/1999/xhtml"))
          (head (title ,(title)))
          (body
           ,(contents)))))

(define conversion-rules
  (append `((*PI* *preorder*
                  . ,(lambda (PI tag . attrs)
                       (list #\< #\? tag
                             (map (lambda (p) (list #\space (car p) "=\"" (cdr p) "\"")) attrs)
                             #\? #\> #\newline)))
            (doctype . ,(lambda (doctype) "<!DOCTYPE HTML>")))
          universal-conversion-rules))

(define (output-html sxml)
  (with-output-to-string
   (lambda ()
     (SRV:send-reply (pre-post-order sxml conversion-rules)))))
