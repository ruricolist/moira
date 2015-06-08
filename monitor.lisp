(in-package #:moira)

(def monitor-flag nil)

(defvar *monitor* nil)

(defun monitor-threads ()
  (loop until monitor-flag
        do (sleep 1)
           (mapc #'ensure-alive (list-monitored-threads))
        finally (nix monitor-flag)))

(defun start-monitor ()
  (synchronized ('*monitor*)
    (etypecase-of a-thread *monitor*
      (live-thread *monitor*)
      ((or no-thread dead-thread)
       (setf *monitor*
             (make-thread-and-wait #'monitor-threads
                                   :name "Thread monitor (Moira)"))))))

(defun stop-monitor ()
  (etypecase-of a-thread *monitor*
    (live-thread
     (setq monitor-flag t)
     (loop while monitor-flag))
    ((or no-thread dead-thread)
     *monitor*)))
