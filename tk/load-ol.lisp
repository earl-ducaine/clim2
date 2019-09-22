;; -*- mode: common-lisp; package: user -*-
;; See the file LICENSE for the full license governing this code.
;;

(in-package :user)

#+dlfcn
(progn
  (defvar sys::*toolkit-shared* nil)

  (unless (ff-wrapper:get-entry-point (ff-wrapper:convert-foreign-name "ol_appl_add_item"))
    (load "clim2:;climol.so")
    (setq sys::*toolkit-shared* t)))

#-dlfcn
(progn
  (defvar sys::*libtk-pathname* "Ol")
  (defvar sys::*libxt-pathname* "Xt")

  (unless (ff-wrapper:get-entry-point (ff-wrapper:convert-foreign-name "XtToolkitInitialize"))
    (load "stub-olit.o"
	  :system-libraries (list sys::*libtk-pathname*
				  sys::*libxt-pathname*
				  sys::*libx11-pathname*)
	  :print t)
    (load "stub-xt.o"
	  :system-libraries (list sys::*libxt-pathname*
				  sys::*libx11-pathname*)
	  :print t))

  (unless (ff-wrapper:get-entry-point (ff-wrapper:convert-foreign-name "ol_appl_add_item"))
    (load "olsupport.o"
	  :system-libraries (list sys::*libtk-pathname*
				  sys::*libxt-pathname*
				  sys::*libx11-pathname*)
	  :print t))

  (unless (ff-wrapper:get-entry-point (ff-wrapper:convert-foreign-name "XtAppIntervalNextTimer"))
    (load "xtsupport.o"
	  :system-libraries (list sys::*libxt-pathname*
				  sys::*libx11-pathname*)
	  :print t)))

(pushnew :clim-openlook *features*)
