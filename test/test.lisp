(defpackage #:parallel-validator/test
  (:use #:coalton #:coalton-prelude #:coalton-testing)
  (:local-nicknames
   (#:tree  #:coalton-library/ord-tree)
   (#:result  #:coalton-library/result))
  (:export #:run-tests))
(in-package #:parallel-validator/test)

(named-readtables:in-readtable coalton:coalton)

(fiasco:define-test-package #:parallel-validator/fiasco-test-package)

(coalton-fiasco-init #:parallel-validator/fiasco-test-package)

(cl:defun run-tests ()
  (fiasco:run-package-tests
   :packages '(#:parallel-validator/fiasco-test-package)
   :interactive cl:t))

(define-test parallel-validator-ok-test ()
  (matches (Ok 3)
      (the (Result (List String) Integer)
           (parallel-validator:let ((x (Ok 1))
                               (y (Ok 2)))
             (pure (+ x y))))))

(define-test parallel-validator-only-x-ok-test ()
  (matches (Err (Cons "y error" (Nil)))
      (parallel-validator:let ((x (Ok 1))
                          (y (Err (make-list "y error"))))
        (pure (+ x y)))))

(define-test parallel-validator-both-error-test ()
  (matches (Err (Cons "x error" (Cons "y error" (Nil))))
      (parallel-validator:let ((x (Err (make-list "x error")))
                          (y (Err (make-list "y error"))))
        (pure (+ x y)))))
