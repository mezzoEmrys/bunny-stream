(in-package :bstream)

(defvar +banned-word-state+ nil)

(define-condition needs-refund (error)
  ((word :initarg word
         :initform nil
         :reader word))
  (:report (lambda (condition stream) (format stream "~A" (word condition)))))

(defun add-banned-word (word)
  (if (not (find word +banned-word-state+ :test #'string-equal))
      (push word +banned-word-state+)
    (error 'needs-refund :word word)))

(defun remove-banned-word (word)
  (if (find word +banned-word-state+ :test #'string-equal)
      (setq +banned-word-state+ (remove word +banned-word-state+ :test #'string-equal))
    (error 'needs-refund :word word)))

(defun clear-banned-words ()
  (if +banned-word-state+
      (setq +banned-word-state+ nil)
    (error 'needs-refund)))