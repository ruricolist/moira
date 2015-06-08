;;;; moira.asd

(asdf:defsystem #:moira
  :description "Describe moira here"
  :author "Your Name <your.name@example.com>"
  :license "Specify license here"
  :depends-on (#:alexandria
               #:serapeum
               #:trivial-features
               #:bordeaux-threads
               #:trivial-garbage
               #:osicat)
  :components ((:file "package")
               (:file "types" :depends-on ("package"))
               (:file "thread-ids" :depends-on ("package"))
               (:file "moira" :depends-on ("package" "types"))
               (:file "monitor" :depends-on ("package" "types"))
               (:file "spawn" :depends-on ("package" "thread-ids" "moira"))))

