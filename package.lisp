;;;; package.lisp

(defpackage #:mailmurder
  (:use #:cl)
  (:export :make-mail :send-mail :send-mail-with-sender))
