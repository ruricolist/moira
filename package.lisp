;;;; package.lisp

(defpackage #:moira
  (:use #:cl #:alexandria #:serapeum)
  #+sbcl
  (:local-nicknames
   (#:bt #:bordeaux-threads)
   (#:tg #:trivial-garbage))
  (:export #:thread-id
           #:save-current-thread-id
           #:make-thread-saving-id
           #:spawn-thread
           #:spawn
           #:start-monitor
           #:stop-monitor
           #:list-monitored-threads))

