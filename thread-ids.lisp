(in-package #:moira)

(declaim (type hash-table *thread-ids*))
(defvar *thread-ids*
  (tg:make-weak-hash-table :weakness :key))

#+linux
(macrolet ((with-thread-id-lock ((&key) &body body)
             #+ccl `(progn ,@body)      ;Lock-free hash tables!
             #-ccl `(synchronized ('*thread-ids*)
                      ,@body)))

  (defun thread-id (thread)
    (with-thread-id-lock ()
      (gethash thread *thread-ids*)))

  (defun id-thread (id)
    (with-thread-id-lock ()
      (maphash
       (lambda (k v) 
         (when (eql v id)
           (return-from id-thread
             k)))
       *thread-ids*)))

  ;; Ensure the later redefinition for linux to be seen.'
  (declaim (notinline save-current-thread-id))
  (defun save-current-thread-id ()
    ;; Overwritten in thread-ids-linux.lisp
    (values)))

#-linux
(progn
  (defun thread-id (thread)
    (declare (ignore thread))
    0)
  (defun save-current-thread-id ()
    (values)))
