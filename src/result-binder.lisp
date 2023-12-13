(defpackage #:result-binder
  (:use #:coalton
        #:coalton-prelude)
  (:shadow #:let)
  (:export #:let))

(cl:in-package #:result-binder)

(named-readtables:in-readtable coalton:coalton)

(coalton-toplevel
  (define-type (LazyResult :w :a)
    (LazyResult :w (Optional :a)))

  (define-instance (Functor (LazyResult :w))
    (define (map f (LazyResult w opt))
      (LazyResult w (map f opt))))

  (define-instance (Monoid :w => Applicative (LazyResult :w))
    (define (pure x)
      (LazyResult mempty (pure x)))
    (define (liftA2 op (LazyResult w1 opt1) (LazyResult w2 opt2))
      (LazyResult (<> w1 w2)
                  (match (Tuple opt1 opt2)
                    ((Tuple (Some x1) (Some x2)) (Some (op x1 x2)))
                    (_ None)))))

  (define-instance (Monoid :w => Monad (LazyResult :w))
    (define (>>= (LazyResult w1 opt1) f)
      (match opt1
        ((None) (LazyResult w1 None))
        ((Some x1)
         (coalton:let (LazyResult w2 opt2) = (f x1))
         (LazyResult (<> w1 w2)
                     (match opt2
                       ((None) None)
                       ((Some x2) (Some x2))))))))

  (declare from-result (Monoid :w => Result :w :a -> LazyResult :w :a))
  (define (from-result r)
    (match r
      ((Ok x) (LazyResult mempty (Some x)))
      ((Err e) (LazyResult e None))))

  (declare to-result (LazyResult :w :a -> Result :w :a))
  (define (to-result (LazyResult e opt))
    (match opt
      ((Some x) (Ok x))
      ((None) (Err e))))

  (declare lazy (Monoid :w => Result :w :a -> LazyResult :w (Optional :a)))
  (define (lazy r)
    (match r
      ((Ok x) (LazyResult mempty (Some (Some x))))
      ((Err e) (LazyResult e (Some None)))))

  (declare force (Monoid :w => Optional :a -> (LazyResult :w :a)))
  (define (force opt)
    (LazyResult mempty opt)))

(cl:defmacro let ((cl:&rest bindings) cl:&body body)
  (cl:let ((gs (cl:loop :for i :to (cl:length bindings) :collect (cl:gensym i))))
    `(to-result
      (do ,@(cl:loop
               :for g :in gs
               :for binding :in bindings
               :collect (cl:list g '<- `(lazy ,(cl:cadr binding))))
          ,@(cl:loop
               :for g :in gs
               :for binding :in bindings
               :collect (cl:list (cl:car binding) '<- `(force ,g)))
        (from-result
         (progn ,@body))))))
