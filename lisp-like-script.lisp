;;;; lisp-like-script.lisp

(in-package :lisp-like-script)

(defparameter *register-symbols* (make-hash-table :test 'equalp))

(defun register-symbol (sym)
  (setf (gethash (symbol-name sym) *register-symbols*) sym))
;(register-symbol 'plus)
;(register-symbol 'minus)
;(register-symbol 'list)

(define-condition not-registered-symbol () 
  ((sym-name :initarg :sym-name :reader not-registered-symbol-sym-name))
  (:report (lambda (condition stream)
             (format stream "Symbol: ~S not registered"
                     (not-registered-symbol-sym-name condition)))))
  
(defun not-doublequote (char)
  (not (eql #\" char)))

(defun not-integer (string)
  (when (find-if-not #'digit-char-p string) 
    t))

(defrule whitespace (+ (or #\Space #\Tab #\Newline))
  (:constant nil))
;(parse 'whitespace "    ")
;(type-of (nth-value 1 (ignore-errors (parse 'whitespace " a "))))

(defrule alphanumeric (alphanumericp character))
;(parse 'alphanumeric "a")

(defrule string-char (or (not-doublequote character))); (and #\\ #\")))
;(parse 'string-char "m")
;;\" - error
;(parse 'string-char "\"")

(defrule string (and #\" (* string-char) #\")
  (:destructure (q1 string q2)
   (declare (ignore q1 q2))
   (text string)))
;(parse 'string "\"sdf\"")

(defrule integer (+ (or "0" "1" "2" "3" "4" "5" "6" "7" "8" "9"))
  (:lambda (list)
    (parse-integer (text list) :radix 10)))
;(parse 'integer "2345")

(defrule symbol (+ (or alphanumeric #\+ #\- #\* #\/))
  (:lambda (list)
    (let* ((sym-name (text list))
           (sym (gethash sym-name *register-symbols*)))
      (unless sym 
        (error 'not-registered-symbol :sym-name sym-name))
      sym)))
;(parse 'symbol "SDF")
;(parse 'symbol "plus")

(defrule atom (or string integer symbol))
;(parse 'atom "\"sdf\"")
;(parse 'atom "list")
;(parse 'atom "345")

(defrule list (and #\( (? whitespace) (? sexp) (? whitespace) (* sexp) (? whitespace) #\))
  (:destructure (p1 w1 car-sexp w2 cdr-sexp w3 p2)
   (declare (ignore p1 w1 w2 w3 p2))
   (if (not car-sexp)
       nil
     (cons car-sexp cdr-sexp))))

(defrule sexp (and (? whitespace) (or list atom) (? whitespace))
  (:destructure (w1 s w2)
   (declare (ignore w1 w2))
   s))
;(assert (not (parse 'list "()")) nil)
#|(assert (parse 'list "(plus (list \"sdf\"  (34) plus) minus)")
    '(plus (list "sdf" (34) plus) minus))
|#

(defun parse-lisp-like-script (script-string &optional (register-symbols-hash *register-symbols*))
  (let ((*register-symbols* register-symbols-hash))
    (parse 'sexp script-string)))
  