(defparameter *results* '())
(defparameter *transform-file-from* "~/dev/clim2/tk/xm-funs-wrapper.in.lisp")
(defparameter *transform-file-to* "~/dev/clim2/tk/xm-funs-wrapper.lisp")

(ql:quickload :iterate)
(use-package :iterate)


(defun load-exprepssions (file)
  (with-open-file (stream )
    (setf *results* nil)
    (do ((expression (read stream nil :eof)
		     (read stream nil :eof)))
	((eq expression :eof)
	 (format t "finished"))
      (push expression *results*)))
