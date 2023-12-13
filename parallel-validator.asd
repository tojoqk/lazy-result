(defsystem #:parallel-validator
  :description "Syntax for delaying result in coalton"
  :author "Masaya Tojo"
  :license  "MIT"
  :version "0.0.0"
  :depends-on (#:coalton)
  :serial t
  :pathname "src/"
  :components ((:file "parallel-validator"))
  :in-order-to ((test-op (test-op "parallel-validator/test"))))

(defsystem #:parallel-validator/test
  :description "Tests of parallel-validator"
  :author "Masaya Tojo"
  :license  "MIT"
  :version "0.0.0"
  :depends-on (#:parallel-validator #:coalton/testing #:fiasco)
  :perform (test-op (o s)
                    (symbol-call '#:parallel-validator/test '#:run-tests))
  :serial t
  :pathname "test/"
  :components ((:file "test")))
