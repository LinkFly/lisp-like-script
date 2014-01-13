;;;; package.lisp
;(ql:quickload :esrap)
(defpackage :lisp-like-script
  (:use :cl :esrap)
  (:export
   #:register-symbol
   #:*register-symbols*
   #:not-registered-symbol
   #:parse-lisp-like-script
   ))

