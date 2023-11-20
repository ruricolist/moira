(in-package #:moira)

#+linux
(macrolet ((with-thread-id-lock ((&key) &body body)
             #+ccl `(progn ,@body)      ;Lock-free hash tables!
             #-ccl `(synchronized ('*thread-ids*)
                      ,@body)))

  (defun save-current-thread-id ()
    (with-thread-id-lock ()
      (let ((thread (bt:current-thread))
            (tid (osicat-posix:gettid)))
        (setf (gethash thread *thread-ids*) tid)))))
