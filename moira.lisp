;;;; moira.lisp

(in-package #:moira)

;;; "moira" goes here. Hacks and glory await!

(declaim (type list *monitored-threads*))
(defvar *monitored-threads* '())

(defun list-monitored-threads ()
  *monitored-threads*)

(defun clear-monitored-threads ()
  (synchronized ('*monitored-threads*)
    (nix *monitored-threads*)))

(defclass monitored-thread ()
  ((lock
    :initform (bt:make-lock)
    :reader serapeum:monitor
    :reader monitored-thread.lock)
   (thread
     :initform nil
     :type a-thread
     :reader monitored-thread.thread)
   (done
    :initform nil
    :type boolean
    :reader monitored-thread.donep)
   (thunk
    :initarg :thunk
    :type function
    :reader monitored-thread.thunk)
   (name
    :initarg :name
    :type string
    :reader monitored-thread.name)))

(defmethods monitored-thread (self thread thunk name done)
  (:method print-object (self stream)
    (print-unreadable-object (self stream :type t)
      (format stream name)
      (when done
        (format stream " (done)"))))
  (:method initialize-instance :after (self &key)
    (synchronized ('*monitored-threads*)
      (pushnew self *monitored-threads*)))
  (:method start (self)
    (etypecase-of a-thread thread
      ((or no-thread dead-thread)
       (setf done nil
             thread (make-thread-and-wait
                     (lambda ()
                       (funcall thunk)
                       (synchronized (self)
                         (setf done t)))
                     :name name)))
      (live-thread (error "Thread is running: ~a" thread))))
  (:method stop (self)
    (etypecase-of a-thread thread
      ((or no-thread dead-thread)
       (nix thread))
      (live-thread
       (bt:destroy-thread (nix thread)))))
  (:method ensure-alive (self)
    (synchronized (self)
      (if done
          (progn
            (synchronized ('*monitored-threads*)
              (removef *monitored-threads* self))
            (stop self))
          (etypecase-of a-thread thread
            (live-thread (values))
            ((or no-thread dead-thread)
             (start self)))))))

