;;; -*- Mode: Lisp; Syntax: ANSI-Common-Lisp; Package: CLIM-UTILS; Base: 10; Lowercase: Yes -*-
;; See the file LICENSE for the full license governing this code.
;;

(in-package :clim-utils)

;;;"Copyright (c) 1991, 1992 Symbolics, Inc.  All rights reserved."

#-PCL
(defgeneric pathname (stream))

(defmethod pathname (stream)
  (cl:pathname stream))

(deftype pathname () 'cl:pathname)


#-PCL
(defgeneric truename (stream))

(defmethod truename (stream)
  (cl:truename stream))
