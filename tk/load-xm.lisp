;; -*- mode: common-lisp; package: user -*-
;; See the file LICENSE for the full license governing this code.
;;

(cl:in-package #:user)

(eval-when (compile eval load)
  (require :climg))

(defvar sys::*clim-library-search-path* '("/usr/X11/lib/" "/usr/X11R6/lib/" "/usr/local/lib/"
                                          "/opt/local/lib/" "/sw/lib/"))

(unless (ff:get-entry-point (ff:convert-foreign-name "XmCreateMyDrawingArea"))
    (load "./climxm.so"))
