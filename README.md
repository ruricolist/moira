# Μοῖρα

Moira is a simple (but not quite trivial) library for monitoring and,
if necessary, restarting long-running threads. In principle, it is
like an in-Lisp process supervisor.

To start the monitor, you call `start-monitor`:

    (moira:start-monitor)

Once the monitor is started, you can spawn new threads:

    (moira:spawn "Background worker"
      ...))

Which is syntactic sugar for

    (moira:spawn-thread
     (lambda () ...)
     :name "Background worker")

If the thread created by `spawn-thread` should crash, or otherwise
exit abnormally, Moira will step in and restart the thread.

You can stop monitoring with `stop-monitor`

    (moira:stop-monitor)

Although this will not affect the spawned threads.

On Linux only, Moira also tracks the thread ID (value of `gettid`) of
the Lisp threads it launches. This can be useful for tracking the
resource usage of individual threads.

You can avoid the Osicat dependency, and not have this latest feature
on Linux, by loading `moira/light`.
