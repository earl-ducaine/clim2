;;; -*- Mode: Lisp; Syntax: ANSI-Common-Lisp; Package: CLX-CLIM; Base: 10; Lowercase: Yes -*-

;; $Header: /repo/cvs.copy/clim2/clx/clx-frames.lisp,v 1.15 1997/02/05 01:46:25 tomj Exp $

(in-package :clx-clim)

"Copyright (c) 1992 Symbolics, Inc.  All rights reserved."


(defclass clx-frame-manager (standard-frame-manager)
    ()
  (:default-initargs :dialog-view +textual-dialog-view+))

(defmethod make-frame-manager ((port clx-port) &key palette &allow-other-keys)
  (make-instance 'clx-frame-manager 
    :port port :palette palette))

(defmethod frame-wrapper ((framem clx-frame-manager) 
			  (frame standard-application-frame) pane)
  (let ((menu-bar (slot-value frame 'menu-bar)))
    (with-look-and-feel-realization (framem frame)
      (outlining ()
	(if menu-bar
	    (vertically ()
	      (compute-menu-bar-pane frame menu-bar)
	      pane)
	    pane)))))
