(defpackage #:multi-result/test
  (:use #:coalton #:coalton-prelude #:coalton-testing)
  (:export #:run-tests))
(in-package #:multi-result/test)

(named-readtables:in-readtable coalton:coalton)

(fiasco:define-test-package #:multi-result/fiasco-test-package)

(coalton-fiasco-init #:multi-result/fiasco-test-package)

(cl:defun run-tests ()
  (fiasco:run-package-tests
   :package '(#:multi-result/fiasco-test-package)
   :interactive cl:t))

;; (define-test multi-result-simple-test ()
;;   (is (Ok 3)
;;       (multi-result:let ((x (Ok 1))
;;                         (y (Ok 2)))
;;         (pure (+ x y)))))
