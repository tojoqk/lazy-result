(defsystem #:validate-with-result
  :description "Syntax for delaying result in coalton"
  :author "Masaya Tojo"
  :license  "MIT"
  :version "0.0.0"
  :depends-on (#:coalton)
  :serial t
  :pathname "src/"
  :components ((:file "validate-with-result"))
  :in-order-to ((test-op (test-op "validate-with-result/test"))))

(defsystem #:validate-with-result/test
  :description "Tests of validate-with-result"
  :author "Masaya Tojo"
  :license  "MIT"
  :version "0.0.0"
  :depends-on (#:validate-with-result #:coalton/testing #:fiasco)
  :perform (test-op (o s)
                    (symbol-call '#:validate-with-result/test '#:run-tests))
  :serial t
  :pathname "test/"
  :components ((:file "test")))
