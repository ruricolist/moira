(in-package #:moira)

(defun thread-alive-p (x)
  (and (bt:threadp x)
       #+ccl (not (ccl:process-exhausted-p x))
       #-ccl (bt:thread-alive-p x)))

(deftype thread ()
  '(satisfies bt:threadp))

(deftype live-thread ()
  '(and thread (satisfies thread-alive-p)))

(deftype dead-thread ()
  '(and thread (not live-thread)))

(deftype no-thread () 'null)

(deftype a-thread ()
  '(or no-thread live-thread dead-thread))


