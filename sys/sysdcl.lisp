;;; -*- Mode: Lisp; Syntax: ANSI-Common-Lisp; Package: CL-USER; Base: 10; Lowercase: Yes -*-
;; See the file LICENSE for the full license governing this code.

(in-package :cl-user)

;; this defines a number of symbols and functions allowing the
;; successful compilation of CLIM in a non-ICS lisp (cim 2/26/96)
#+ignore (require :ics)

#+(and allegro (not acl86win32) (not (version>= 6 1)))
(let ((*enable-package-locked-errors* nil))
  (export '(excl::codeset-0 excl::codeset-1 excl::codeset-2 excl::codeset-3
	    excl::string-to-euc excl::euc-to-string)
	  (find-package :excl))
  (export '(ff::euc-to-char* ff::char*-to-euc ff::wchar*-to-string) (find-package :ff)))

"Copyright (c) 1990, 1991, 1992 Symbolics, Inc.  All rights reserved."

(eval-when (compile load eval)

;;; Tell the world that we're here
;;;--- These need to be in the CLIM.fasl also.
;;;--- Currently they're in EXCL-VERIFICATION but that does not seem the best place.
(pushnew :clim *features*)
(pushnew :clim-2 *features*)
(pushnew :clim-2.1 *features*)
(pushnew :silica *features*)

)	;eval-when

#+(or aclpc acl86win32)
(progn
  ; (pushnew :use-fixnum-coordinates *features*)
  ;;mm: to suppress many compiler warnings.
  (declaim (declaration values arglist))
  )

#+allegro
(declaim (declaration non-dynamic-extent))


;;; CLIM is implemented using the "Gray Stream Proposal" (STREAM-DEFINITION-BY-USER)
;;; a proposal to X3J13 in March, 1989 by David Gray of Texas Instruments.  In that
;;; proposal, stream objects are built on certain CLOS classes, and stream functions
;;; (e.g., WRITE-CHAR) are non-generic interfaces to generic functions (e.g.,
;;; STREAM-WRITE-CHAR).  These "trampoline" functions are required because their
;;; STREAM argument is often optional, which means it cannot be used to dispatch to
;;; different methods.

;;; Various Lisp vendors have their own stream implementations, some of which are
;;; identical to the Gray proposal, some of which implement just the trampoline
;;; functions and not the classes, etc.  If the Lisp vendor has not implemented the
;;; classes, we will shadow those class names (and the predicate functions for them)
;;; in the CLIM-LISP package, and define the classes ourselves.  If the vendor has
;;; not implemented the trampoline functions, we will shadow their names, and write
;;; our own trampolines which will call our generic function, and then write default
;;; methods which will invoke the COMMON-LISP package equivalents.

(eval-when (compile load eval)

#+(or allegro
      Minima)
(pushnew :clim-uses-lisp-stream-classes *features*)

#+(or allegro
      Genera				;Except for STREAM-ELEMENT-TYPE
      Minima
      Cloe-Runtime
      CCL-2)				;Except for CLOSE (and WITH-OPEN-STREAM)
(pushnew :clim-uses-lisp-stream-functions *features*)

;;; CLIM-ANSI-Conditions means this lisp truly supports the ANSI CL condition system
;;; CLIM-Conditions      means that it has a macro called DEFINE-CONDITION but that it works
;;;                      like allegro 3.1.13 or Lucid.
(pushnew :clim-ansi-conditions *features*)

#+allegro
(pushnew :allegro-v4.0-constructors *features*)

)	;eval-when

;; We extend defsystem to have a new module class compile-always
;; which always recompiles the module even if not required. This
;; allows us to put defpackage forms within ics-target-case so that at
;; load time only the one case takes effect while at compile time both
;; forms are processed. (cim 2/28/96)

(defclass compile-always (defsystem:lisp-module)
  ())

(defvar *compiled-modules* nil)

(defmethod defsystem:product-newer-than-source ((module compile-always))
  (member module *compiled-modules*))

(defmethod defsystem:compile-module :after ((module compile-always) &key)
  (pushnew module *compiled-modules*))

;; This defsystem module class only compiles the module if it's not
;; ever been compiled - this is used to deal with files that can only
;; be validly compiled with an ics image - see japanese-input-editor
;; (cim 2/28/96)

(defclass compile-once (defsystem:lisp-module)
  ())

(defmethod defsystem:product-newer-than-source ((module compile-once))
  (probe-file (defsystem:product-pathname module)))




(defsystem clim-utils
    (:default-pathname "clim2:;utils;")
  ;; These files establish a uniform Lisp environment
  (:serial
   ))

(defsystem clim-silica
    (:default-pathname "clim2:;silica;")
  (:serial
   ))

(defsystem clim-standalone
  (:default-pathname "clim2:;clim;")
  (:serial
   clim-silica
   ))

(defsystem xlib
    (:default-pathname "clim2:;xlib;")
  (:serial
   clim-standalone
   ))

(defsystem last
  (:default-pathname "clim2/utils")
  (:serial ("last")))
