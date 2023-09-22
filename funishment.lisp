(in-package :bstream)
(defvar +funishment-timers+ nil)
(defvar *default-timer-length* 10)
(defvar *general-funishments*)

(setq *general-funishments* 
        '(("Free banned word" :desc "Chat decides what word gets banned!" 
                              :type event)
          ("Mezzo-chan" :type model)
          ("Offbrand Minecraft" :type model)
          ("Put her in the deep frier" :type model)
          ("Return to the Sea" :type model)
          ("'M (00)" :type model :weight ultra-rare)
          ("The Slime!" :type timer)
          ("Now you see her..." :type timer)
          ("Shahzarad" :desc "Minigame! If she wins in one shot, she gets to remove a banned word! If she loses, she spins again." 
                       :type event :weight ghost-rare)
          ("The new Murple" :desc "Hue shift! Chat picks a number between -180 and 180." 
                            :type timer)
          ("Crowd Control" :desc "Chat can tell her to do any ingame action until the timer runs out!"
                           :type timer :weight rare)
          ("Invert Controls" :type timer :weight rare :length 2)
          ("Copypasta speedrun" :desc "Chat picks a copypasta for her to speedrun."
                                :type event)
          ("Copypawsta speedwun" :desc "Chat picks a copypawsta fow hew to speedwun."
                                :type event :weight rare)
          ("Starving Artist moment" :desc "Speedpaint of some kind of chat fanart."
                                    :type event :weight ultra-rare)
          ("Opposite Day" :desc "She can only use BANNED words."
                                    :type event :weight ghost-rare)
          ("'M (FF)" :type event :weight error-rare)))

(defun value-of-key (key list)
  (if (find key list)
    (nth (+ 1 (position key list)) list)))

(defun has-type-p (type)
  (lambda (entry) (eq type (value-of-key :type entry))))

(defun weight-of (funishment)
  (cond
    ((eq (value-of-key :weight funishment) 'rare) 40)
    ((eq (value-of-key :weight funishment) 'ultra-rare) 10)
    ((eq (value-of-key :weight funishment) 'ghost-rare) 1)
    ((eq (value-of-key :weight funishment) 'error-rare) 0)
    (t 100)))

(defun length-of (funishment)
  (if (find :length funishment)
      (value-of-key :length funishment)
    *default-timer-length*))

(defun select-funishment ()
  (let ((choices *general-funishments*))
    ;limit list
    (if (find-if (has-type-p 'model) +funishment-timers+)
      (setq choices (remove-if (has-type-p 'model) choices)))
    ;weighted selection
    (let* ((weight-sum (reduce #'+ (mapcar #'weight-of choices)))
           (selected-value (random weight-sum)))
      (loop for option in choices
            with cumulative = selected-value
            do(if (<= (setq cumulative (- cumulative (weight-of option))) 0)
                  (return option))))))

(defun matches-name (name)
  (lambda (value) (string-equal name (car value))))

(defvar *message-url* "http://127.0.0.1:8911/api/v2/chat/message/")

(defun remove-timer (name)
  (let ((match (find-if (matches-name name) +funishment-timers+)))
    (if match
        (trivial-timer:cancel-timer-call (value-of-key :id match)))
    (setq +funishment-timers+ (remove-if (matches-name name) +funishment-timers+))))

(defun report-timer-complete (funishment)
  (let ((name (car funishment)))
    (lambda ()
      (format t "Clearing funishment ~a~&" name)
      (remove-timer name))))

;     (drakma:http-request *message-url*
;        :content-type "application/json"
;        :external-format-out :utf-8
;        :method :post
;        :external-format-in :utf-8
;        :content (json:encode-json-to-string 
;                  (list '("Platform" . "Twitch")
;                    (cons "Message" (format nil "Time's up for ~a" name))
;                    '("SendAsStreamer" . nil)))

(defun make-timer (funishment)
  (remove-timer (car funishment))
  (list (car funishment)
        :type (value-of-key :type funishment)
        :id (trivial-timer:register-timer-call (* 1000 60 (length-of funishment)) (report-timer-complete funishment))))

(defun roll-funishment ()
  (let ((selected (select-funishment)))
    (if (not (eq (value-of-key :type selected) 'event))
      (push (make-timer selected) +funishment-timers+))
    (cons (car selected) (value-of-key :desc selected))))