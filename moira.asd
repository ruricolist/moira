;;;; moira.asd

(asdf:defsystem #:moira/light
  :description "Moira base system without the Osicat dependency, hence without thread id support on Linux."
  :author "Paul M. Rodriguez <pmr@ruricolist.com>"
  :license "MIT"
  :depends-on (#:alexandria
               #:serapeum
               #:trivial-features
               #:bordeaux-threads
               #:trivial-garbage)
  :components ((:file "package")
               (:file "types" :depends-on ("package"))
               (:file "thread-ids" :depends-on ("package"))
               (:file "moira" :depends-on ("package" "types"))
               (:file "monitor" :depends-on ("package" "types"))
               (:file "spawn" :depends-on ("package" "thread-ids" "moira"))))

(asdf:defsystem #:moira
  :description "Monitor and restart background threads."
  :author "Paul M. Rodriguez <pmr@ruricolist.com>"
  :license "MIT"
  :depends-on (#:moira/light
               #:osicat)
  :components ((:file "thread-ids-linux")))
