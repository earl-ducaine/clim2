;; -*- mode: common-lisp; package: user -*-
;;
;; See the file LICENSE for the full license governing this code.
;;

(in-package :user)

;; Forgive them, lord, for they know not what they do.
(eval-when (compile load eval)
  (pushnew :ansi-90 *features*))

(eval-when (compile load eval)
  (setq comp:declared-fixnums-remain-fixnums-switch
	(named-function |(> speed 2)|
			(lambda (safety size speed debug compilation-speed)
			  (declare (ignore safety size debug compilation-speed))
			  (> speed 2)))))

(eval-when (compile load eval)
;;;; Set up translations so we can find stuff.
  (setf (logical-pathname-translations "clim2")
	(list (list ";**;*.*"
		    (format nil "~A**/*.*"
			    (directory-namestring
			     (make-pathname
			      :directory
			      (butlast (pathname-directory
					*load-pathname*)))))))))

(eval-when (compile load eval)
  (load "clim2:;sys;sysdcl"))

(eval-when (compile load eval)
  (load "clim2:;postscript;sysdcl"))

(eval-when (compile load eval)
  (load "clim2:;hpgl;sysdcl"))

(eval-when (compile load eval)
  (load "clim2:;demo;sysdcl"))

(eval-when (compile load eval)
  (load "clim2:;test;testdcl"))

(eval-when (compile load eval)
  (when (probe-file "clim2:;climtoys;sysdcl.lisp")
    (load "clim2:;climtoys;sysdcl")))

(eval-when (compile load eval)
  (defsystem climg
    ()
    (:serial
     clim-standalone			;from sys;sysdcl
     )))

(eval-when (compile load eval)
  (defsystem climdemo
    ()
    (:serial
     )))

(eval-when (compile load eval)
  (defsystem empty-cat
    ;; so we can make empty fasls trivially
    ()
    (:serial)))

(eval-when (compile load eval)
  (defsystem xlib-cat
    ;; a cattable xlib, see clim2:;sys;sysdcl
    (:default-pathname "clim2:;xlib;")
    (:serial
     )))

(defsystem xm-tk-cat
  (:default-pathname #p"clim2:;tk;")
  (:serial
   ("load-xm")
   xlib-cat))

;; (eval-when (compile load eval)
;;   (define-xt-cat-system xm-tk-cat "load-xm"
;;     ))

(eval-when (compile load eval)
  (defsystem motif-clim-cat
    ;; cattable motif-clim, see clim2:;sys;sysdcl
    (:default-pathname "clim2:;tk-silica;")
    (:serial
     xm-tk-cat
     )))
