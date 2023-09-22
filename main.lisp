(in-package :bstream)

(hunchentoot:define-easy-handler 
    (ban-word :uri "/ban-word" :default-request-type :get)
    ((word :parameter-type 'string))
    (handler-case (progn (add-banned-word (string-trim " " word))
                         (format nil "success"))
      (needs-refund ()
        (format nil "failed"))))

(hunchentoot:define-easy-handler 
    (unban-word :uri "/unban-word" :default-request-type :get)
    ((word :parameter-type 'string))
    (handler-case (progn (remove-banned-word (string-trim " " word))
                         (format nil "success"))
      (needs-refund ()
        (format nil "failed"))))

(hunchentoot:define-easy-handler 
    (banned-words :uri "/banned-words" :default-request-type :get)
    ()
    (format nil "The streamer can't say the following words: ~{~A~^, ~}" +banned-word-state+))

(hunchentoot:define-easy-handler 
    (clear-banned :uri "/clear-banned-words" :default-request-type :get)
    ()
    (progn (clear-banned-words)
         (format nil "success")))

(hunchentoot:define-easy-handler 
    (funishment-roll :uri "/roll-funishment" :default-request-type :get)
    ()
    (let ((choice (roll-funishment)))
      (format t "Rolled funishment: ~a~&" (car choice))
      (format nil "~a" (json:encode-json-to-string (list (cons "name" (car choice))
                                                       (cons "desc" (cdr choice)))))))

(defvar *acceptor* nil)

(defun start-server (&optional (port 5011))
  (trivial-timer:initialize-timer)
  (setf *random-state* (make-random-state t))
  (hunchentoot:start (setf *acceptor*
                       (make-instance 'hunchentoot:easy-acceptor :port port))))

(defun stop-server ()
  (trivial-timer:shutdown-timer)
  (hunchentoot:stop *acceptor*))

(defun main ()
  (start-server)
  (sleep most-positive-fixnum))

;(sb-ext:save-lisp-and-die "server.exe" :toplevel #'bstream::main :executable t)