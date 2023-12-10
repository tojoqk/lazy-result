(defsystem #:lazy-result
  :description "Syntax for delaying result in coalton"
  :author "Masaya Tojo"
  :license  "MIT"
  :version "0.0.0"
  :depends-on (#:coalton)
  :serial t
  :pathname "src/"
  :components ((:file "lazy-result"))
  :in-order-to ((test-op (test-op "lazy-result/test"))))

(defsystem #:lazy-result/test
  :description "Tests of lazy-result"
  :author "Masaya Tojo"
  :license  "MIT"
  :version "0.0.0"
  :depends-on (#:lazy-result #:coalton/testing #:fiasco)
  :perform (test-op (o s)
                    (symbol-call '#:lazy-result/test '#:run-tests))
  :serial t
  :pathname "test/"
  :components ((:file "test")))
