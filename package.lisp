;; See the file LICENSE for the full license governing this code.


(defpackage :x11
  ;; I don't know if this is OK (can we assume clim-utils?).  In any
  ;; case we want that definition of fintern.
  (:import-from :clim-utils :fintern)

  ;; These next two import symbols when loading from clim.fasl.
  (:export #:int #:short)
  (:export #:int def-c-type def-c-typedef)
  (:export #:screen #:depth #:visual #:colormap
	   #:pixmap #:window #:display))

(defpackage :tk
  (:use :common-lisp)
  (:nicknames :xt)
  (:import-from :clim-utils #:fintern #:package-fintern)
  (:import-from :x11 def-c-type def-c-typedef)
  (:export
   #:initialize-motif-toolkit
   #:widget-parent
   #:manage-child
   #:get-values
   #:top-level-shell
   #:popup
   #:popdown
   #:manage-child
   #:realize-widget
   #:card32
   #:card29
   #:card24
   #:card16
   #:card8
   #:int32
   #:int16
   #:int8
   #:with-server-grabbed
   #:window-property-list))

#+allegro
(setf (package-definition-lock (find-package :tk)) t)
