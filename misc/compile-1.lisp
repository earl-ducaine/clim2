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

;;;; system definitions we need

;;; Basic clim and also all the X stuff
(eval-when (compile load eval)
  (load "clim2:;sys;sysdcl"))

;;; postscript stuff
(eval-when (compile load eval)
  (load "clim2:;postscript;sysdcl"))

;;; HPGL, only for Unix
(eval-when (compile load eval)
  (load "clim2:;hpgl;sysdcl"))

;;; demo stuff
(eval-when (compile load eval)
  (load "clim2:;demo;sysdcl"))

;;; testing stuff (this is really a serious mess)
(eval-when (compile load eval)
  (load "clim2:;test;testdcl"))

;;; climtoys.  I think this is never there, but just to be compatible.
(eval-when (compile load eval)
  (when (probe-file "clim2:;climtoys;sysdcl.lisp")
    (load "clim2:;climtoys;sysdcl")))

(eval-when (compile load eval)
  (defsystem climg
    ;; climg is generic clim and ends up as climg.fasl.  This is
    ;; clim-standalone + the PS stubs.
    ()
    (:serial
     clim-standalone			;from sys;sysdcl
     )))

(eval-when (compile load eval)
  (defsystem climdemo
    ;; climdemo.fasl.  This is a hack becuse files used by the system
    ;; in test;sysdcl have nasties in, other than that we could
    ;; probably make this be just clim-demo + clim-tests.
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

(defmacro define-xt-cat-system (name file &rest modules)
  ;; this is like define-xt-system but uses xlib-cat, not xlib.  See
  ;; clim2:;sys;sysdcl.  The `special' file comes before the xlib
  ;; system because it can do various require-type things: I'm not
  ;; sure this is right.
  `(defsystem ,name
       (:default-pathname #p"clim2:;tk;")
     (:serial
      (,file)
      xlib-cat
      ,@modules)))

(eval-when (compile load eval)
  (define-xt-cat-system xm-tk-cat "load-xm"
    ;; cattable xm-tk, see clim2:;sys;sysdcl
    ;; ("xm-defs")
    ;; ("xm-funs")
    ;; ("xm-classes")
    ;; ("xm-callbacks")
    ;; ("xm-init")
    ;; ("xm-widgets")
    ;; ("xm-font-list")
    ;; ("xm-protocols")
    ;; ("convenience")
    ;; ("make-widget")
    ))

(eval-when (compile load eval)
  (defsystem motif-clim-cat
    ;; cattable motif-clim, see clim2:;sys;sysdcl
    (:default-pathname "clim2:;tk-silica;")
    (:serial
     xm-tk-cat
     )))


;;; Compiling a system.
;;;
;;; This is just hard-wired -- the makefile says (compile-it
;;; <something>), which determines which top-level system to build,
;;; but all the other systems are wired in here.  And currently there
;;; is only one possible top-level system per platform, unless by some
;;; miracle the openlook stuff still built!
(defun compile-it (sys)
  (with-compilation-unit ()
		   (excl:compile-system sys :include-components t)))
