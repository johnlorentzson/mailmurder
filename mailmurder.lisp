;;;; mailmurder.lisp

(in-package #:mailmurder)

(defclass mail ()
  ((subject :accessor mail-subject
             :initarg :subject
             :initform "")
   (to :accessor mail-to
        :initarg :to
        :initform (error "At least one recipient needed."))
   (attachment :accessor mail-attachment
                :initarg :attachment
                :initform nil)
   (body :accessor mail-body
          :initarg :body
          :initform (error "Mail body is needed."))))

(defun make-mail (subject recipients body &optional attachment)
  (make-instance 'mail :subject subject :body body :to recipients :attachment attachment))

;;; Sending

(defclass mail-sender () ())

(defgeneric send-mail-with-sender (mail sender))

(defvar *mutt-file-counter* 0)
(defparameter *print-commands* nil)
(defclass mutt-mail-sender (mail-sender) ())

(defmethod send-mail-with-sender ((mail mail) (sender mutt-mail-sender))
  (let ((mail-body-filepath (format nil "/tmp/mm-mutt-~D" (incf *mutt-file-counter*))))
    (with-open-file (body-stream mail-body-filepath
                                 :direction :output :if-does-not-exist :create)
      (write-string (mail-body mail) body-stream))
    (let* ((subject (format nil "-s \"~A\"" (mail-subject mail)))
           (to (with-output-to-string (to-stream)
                 (dolist (recipient (mail-to mail))
                   (format to-stream "\"~A\" " recipient))))
           (attachment (if (mail-attachment mail)
                           (format nil "-a \"~A\"" (mail-attachment mail))
                           ""))
           (command (format nil "mutt ~A ~A -- ~A < ~A"
                            subject attachment to mail-body-filepath)))
      (when *print-commands*
        (write-string command))
      (uiop:run-program command))
    (delete-file mail-body-filepath)))

(defvar *default-sender* (make-instance 'mutt-mail-sender))
(defun send-mail (mail)
  (send-mail-with-sender mail *default-sender*))
