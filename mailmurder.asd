;;;; mailmurder.asd

(asdf:defsystem #:mailmurder
  :description "Mailmurder uses mutt to let my Lisp programs send email."
  :author "John Lorentzson"
  :license  "MIT License"
  :version "0.0.1"
  :serial t
  :components ((:file "package")
               (:file "mailmurder")))
