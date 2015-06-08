# Μοῖρα

Moira provides high-level thread management. At the moment, it has
only two features:

- On Linux only, it tracks the thread ID (value of `gettid`) of Lisp
  threads.

- It provides automatically respawning threads: if the thread exists
  abnormally, it gets restarted.
