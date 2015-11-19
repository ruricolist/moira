(in-package #:moira)

(defun make-thread-saving-id (thunk &rest args)
  "Like `bt:make-thread', but save the id of the resulting thread so
it can be retrieved later with `moira:thread-id'.

Using `moira:make-thread-saving-id' lets you start a thread that is
not monitored, but does have its ID tracked."
  (apply #'bt:make-thread
         (lambda ()
           (save-current-thread-id)
           (funcall thunk))
         args))

(defun make-thread-and-wait (thunk &rest args)
  "Like `make-thread-saving-id', but wait to return until the thread
is actually running."
  (lret* ((ready nil)
          (thread (apply #'make-thread-saving-id
                         (lambda ()
                           (setf ready t)
                           (funcall thunk))
                         args)))
    (loop until ready)
    (assert (typep thread 'live-thread))))

(defun spawn-thread (thunk &key name)
  "Run THUNK as a thread, automatically respawning if the thread exits
abnormally."
  (let ((mt (make 'monitored-thread
                  :thunk thunk
                  :name name)))
    (start mt)
    (values (monitored-thread.thread mt)
            mt)))

(defmacro spawn (&body body)
  "Like (spawn-thread (lambda () ...)).
If the first form in BODY is a string, that string is used as the name
of the thread."
  (let ((name (when (stringp (car body)) (pop body))))
    `(spawn-thread
      (lambda () ,@body)
      :name ,name)))
