(defsystem #:result-binder
  :description "Syntax for delaying result in coalton"
  :author "Masaya Tojo"
  :license  "MIT"
  :version "0.0.0"
  :depends-on (#:coalton)
  :serial t
  :pathname "src/"
  :components ((:file "result-binder"))
  :in-order-to ((test-op (test-op "result-binder/test"))))

(defsystem #:result-binder/test
  :description "Tests of result-binder"
  :author "Masaya Tojo"
  :license  "MIT"
  :version "0.0.0"
  :depends-on (#:result-binder #:coalton/testing #:fiasco)
  :perform (test-op (o s)
                    (symbol-call '#:result-binder/test '#:run-tests))
  :serial t
  :pathname "test/"
  :components ((:file "test")))
