(defpackage #:lazy-result/test
  (:use #:coalton #:coalton-prelude #:coalton-testing)
  (:local-nicknames
   (#:tree  #:coalton-library/ord-tree)
   (#:result  #:coalton-library/result))
  (:export #:run-tests))
(in-package #:lazy-result/test)

(named-readtables:in-readtable coalton:coalton)

(fiasco:define-test-package #:lazy-result/fiasco-test-package)

(coalton-fiasco-init #:lazy-result/fiasco-test-package)

(cl:defun run-tests ()
  (fiasco:run-package-tests
   :packages '(#:lazy-result/fiasco-test-package)
   :interactive cl:t))

(define-test lazy-result-ok-test ()
  (matches (Ok 3)
      (the (Result (List String) Integer)
           (lazy-result:let ((x (Ok 1))
                             (y (Ok 2)))
             (pure (+ x y))))))

(define-test lazy-result-only-x-ok-test ()
  (matches (Err (Cons "y error" (Nil)))
      (lazy-result:let ((x (Ok 1))
                        (y (Err (make-list "y error"))))
        (pure (+ x y)))))

(define-test lazy-result-both-error-test ()
  (matches (Err (Cons "x error" (Cons "y error" (Nil))))
      (lazy-result:let ((x (Err (make-list "x error")))
                        (y (Err (make-list "y error"))))
        (pure (+ x y)))))
