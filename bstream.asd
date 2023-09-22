(asdf:defsystem #:bstream 
  :components ((:file "package")
               (:file "funishment")
               (:file "banned-words")
               (:file "main"))
  :depends-on (:hunchentoot
               :drakma
               :cl-json
               :trivial-timer))