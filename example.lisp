(defpackage :lisp-like-script.example
  (:use :cl :lisp-like-script))

(in-package :lisp-like-script.example)

(register-symbol 'list)
(register-symbol 'first)
(register-symbol 'rest)
(register-symbol '+)
(register-symbol '-)
(register-symbol '*)
(register-symbol '/)

(defun walk-my-dialect (parsed-sexp)
  (if (atom parsed-sexp)
      parsed-sexp
    (apply (first parsed-sexp) 
           (mapcar 'walk-my-dialect
                   (rest parsed-sexp)))))

  
(defun eval-my-dialect (my-dialect-script &aux parsed-sexp)
  (setf parsed-sexp (parse-lisp-like-script my-dialect-script))
  (walk-my-dialect parsed-sexp))

#|(assert (equal (eval-my-dialect "
(rest
 (list (+ 1 2)
       (* 3 4)
       (first
        (list \"one\" \"two\"))))
")
               '(12 "one")))
|#
                                
               '



