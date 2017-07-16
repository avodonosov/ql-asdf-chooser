(in-package :cl-user)

(print ">>> Building system....")
(require 'asdf)
(asdf:disable-output-translations)
(require-quicklisp :version "2013-02-17")
(let* ((this-file (load-time-value (or *load-truename* #.*compile-file-pathname*)))
       (this-file-dir (make-pathname :directory (pathname-directory this-file))))
  (push this-file-dir asdf:*central-registry*))
(ql:quickload :qach-proxy)

(print ">>> saving image qach-proxy...")
(sb-ext:save-lisp-and-die (merge-pathnames "qach-proxy" *build-dir*)
                          :toplevel (lambda ()
                                      (ad-proxy:start :port (parse-integer (asdf::getenv "PORT")))
                                      (loop (sleep 1000)))
                          :executable t
                          :purify t)

(print ">>> Done building system")
