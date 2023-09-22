
(ql:quickload "cl-json")
(ql:quickload "drakma")

(defvar command_id)
(defvar url)
(defvar args)
(defvar m-url)
(defvar m-args)

(setq command_id "todo")
(setq url (concatenate 'string "http://localhost:8911/api/commands/" command_id))

(setq args '(("Platform" . "Twitch")
             ("Arguments" . "test1 | desc1")))

(defun try-get ()
  (flexi-streams:octets-to-string
    (drakma:http-request "http://localhost:8911/api/commands/"
      :method :post
      :content-type "application/json"
      :external-format-out :utf-8
      :external-format-in :utf-8)))

(defun try ()
  (flexi-streams:octets-to-string
    (drakma:http-request url
      :method :post
      :content-type "application/json"
      :external-format-out :utf-8
      :external-format-in :utf-8
      :content (json:encode-json-to-string args))))

(setq m-args '(("Platform" . "Twitch")
               ("Message" . "test1 | desc1")
               ("SendAsStreamer" . nil)))

(setq m-url "http://localhost:8911/api/v2/chat/message/")

(defun message ()
  (flexi-streams:octets-to-string
    (drakma:http-request m-url
      :method :post
      :content-type "application/json"
      :external-format-out :utf-8
      :external-format-in :utf-8
      :content (json:encode-json-to-string m-args))))