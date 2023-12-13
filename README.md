# result-binder

Syntax `let` for delaying result in coalton.

## Installation

Since it depends on Coalton, please refer to the link below to install Coalton.

https://github.com/coalton-lang/coalton

Next, place result-binder in your local repository (`~/common-lisp`, etc.).

```shell:~/common-lisp
git clone https://github.com/tojoqk/result-binder.git
```

If you are using Quicklisp, you can load the system with the following.

```lisp
(ql:quickload :result-binder)
```

## Usage

```
(result-binder:let ((<var1> <result-type-value1>)
                  (<var2> <result-type-value2>)
                  ...)
  <expr> ...)
```

Type of Err must be monoid.

## Examples

```
(defpackage #:result-binder-example
  (:use #:coalton
        #:coalton-prelude)
  (:local-nicknames
   (#:string #:coalton-library/string)))

(in-package #:result-binder-example)

(named-readtables:in-readtable coalton:coalton)

(coalton-toplevel
  (define parse-name Ok)

  (define (parse-age x)
    (match (string:parse-int x)
      ((Some n)
       (if (<= 1 n)
           (Ok n)
           (Err (make-list "parse-age-error (negative)"))))
      ((None) (Err (make-list "parse-age-error")))))

  (define-type Status
    Sleeping
    Studying)

  (define (parse-status x)
    (match x
      ("sleeping" (Ok sleeping))
      ("studying" (Ok Studying))
      (_ (Err (make-list "parse-status-error")))))

  (define case-ok
    (result-binder:let ((name (parse-name "john"))
                        (age (parse-age "28"))
                        (status (parse-status "sleeping")))
      (Ok (Tuple3 name age status))))

  (define case-err-1
    (result-binder:let ((name (parse-name "john"))
                        (age (parse-age "-28"))
                        (status (parse-status "studying")))
      (Ok (Tuple3 name age status))))

  (define case-err-2
    (result-binder:let ((name (parse-name "john"))
                        (age (parse-age "twenty"))
                        (status (parse-status "playing")))
      (Ok (Tuple3 name age status)))))
```

REPL:

```
RESULT-BINDER-EXAMPLE> (coalton case-ok)
#.(OK #.(TUPLE3 "john" 28 #.SLEEPING))
RESULT-BINDER-EXAMPLE> (coalton case-err-1)
#.(ERR ("parse-age-error (negative)"))
RESULT-BINDER-EXAMPLE> (coalton case-err-2)
#.(ERR ("parse-age-error" "parse-status-error"))
RESULT-BINDER-EXAMPLE>
```

## LICENSE

This program is licensed under the MIT License. See the LICENSE file for details.
