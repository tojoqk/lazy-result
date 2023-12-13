(defpackage #:result-binder/test
  (:use #:coalton #:coalton-prelude #:coalton-testing)
  (:local-nicknames
   (#:tree  #:coalton-library/ord-tree)
   (#:result  #:coalton-library/result))
  (:export #:run-tests))
(in-package #:result-binder/test)

(named-readtables:in-readtable coalton:coalton)

(fiasco:define-test-package #:result-binder/fiasco-test-package)

(coalton-fiasco-init #:result-binder/fiasco-test-package)

(cl:defun run-tests ()
  (fiasco:run-package-tests
   :packages '(#:result-binder/fiasco-test-package)
   :interactive cl:t))

(define-test result-binder-ok-test ()
  (matches (Ok 3)
      (the (Result (List String) Integer)
           (result-binder:let ((x (Ok 1))
                               (y (Ok 2)))
             (pure (+ x y))))))

(define-test result-binder-only-x-ok-test ()
  (matches (Err (Cons "y error" (Nil)))
      (result-binder:let ((x (Ok 1))
                          (y (Err (make-list "y error"))))
        (pure (+ x y)))))

(define-test result-binder-both-error-test ()
  (matches (Err (Cons "x error" (Cons "y error" (Nil))))
      (result-binder:let ((x (Err (make-list "x error")))
                          (y (Err (make-list "y error"))))
        (pure (+ x y)))))
