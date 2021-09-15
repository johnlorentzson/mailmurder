;;;; package.lisp

(defpackage #:mailmurder
  (:use #:cl)
  (:export :make-mail :send-mail :send-mail-with-sender
           :mail-subject :mail-to :mail-attachment :mail-body))
