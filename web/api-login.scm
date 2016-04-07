(use uri-common)

;; XXX session-id collision?
(define (new-session account)
  (let ((ssid (new-session-id)))
    (insert-session ssid account)
    (set-cookie! "session-id" ssid
                 path: (uri-reference "/api/")
                 ;; secure: #t
                 http-only: #t)))

(define (login-form)
  (parameterize
      ((title "Login")
       (contents
        `(form (@ (action "/api/login")
                  (method "post"))
               (p (label (@ (for "username")) "Username: ") (input (@ (name "username") (type "text"))))
               (p (label (@ (for "password")) "Password: ") (input (@ (name "password") (type "password"))))
               (p (button (@ (name "submit")) "Login")))))
    (page-template)))

(define (api-login-get c)
  (cond ((aand (read-cookie "session-id") (session it))
         => (lambda (session)
              (send-response body: (output-html `(p "Logged in as " ,(alist-ref 'account session))))))
        (else
         (send-response body: (output-html (login-form))))))

(define (api-login-post c)
  (let* ((params (read-urlencoded-request-data (current-request)))
         (username (alist-ref 'username params))
         (req-password (alist-ref 'password params)))
    (cond ((aand (read-cookie "session-id") (session it))
           (api-login-get c))
          ((not (and (string? username) (string? req-password)))
              (send-status 'bad-request))
          ((aand (password username) (string=? (crypt req-password it) it))
           (new-session username)
           (send-response status: 'ok body: "login success!" headers: '((content-type text/plain))))
          (else
           (send-response status: 'unauthorized body: "login failed :(" headers: '((content-type text/plain)))))))

