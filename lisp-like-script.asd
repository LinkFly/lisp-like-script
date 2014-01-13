;;;; lisp-like-script.asd

(asdf:defsystem #:lisp-like-script
  :serial t
  :description "Library for defining small lisp-like scripts languages"
  :author "Sergey Katrevich <linkfly1@newmail.ru>"
  :license "LLGPL"
  :depends-on (#:esrap)
  :components ((:file "package")
               (:file "lisp-like-script")))

