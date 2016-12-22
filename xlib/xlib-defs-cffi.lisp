;; See the file LICENSE for the full license governing this code.
;;

;;; (c) Copyright  1990 Sun Microsystems, Inc.  All Rights Reserved.
;;      (c) Copyright 1989, 1990, 1991 Sun Microsystems, Inc. Sun design
;;      patents pending in the U.S. and foreign countries. OPEN LOOK is a
;;      registered trademark of USL. Used by written permission of the owners.
;;
;;      (c) Copyright Bigelow & Holmes 1986, 1985. Lucida is a registered
;;      trademark of Bigelow & Holmes. Permission to use the Lucida
;;      trademark is hereby granted only in association with the images
;;      and fonts described in this file.
;;
;;      SUN MICROSYSTEMS, INC., USL, AND BIGELOW & HOLMES
;;      MAKE NO REPRESENTATIONS ABOUT THE SUITABILITY OF
;;      THIS SOURCE OR OBJECT CODE FOR ANY PURPOSE. IT IS PROVIDED "AS IS"
;;      WITHOUT EXPRESS OR IMPLIED WARRANTY OF ANY KIND.
;;      SUN  MICROSYSTEMS, INC., USL AND BIGELOW  & HOLMES,
;;      SEVERALLY AND INDIVIDUALLY, DISCLAIM ALL WARRANTIES
;;      WITH REGARD TO THIS CODE, INCLUDING ALL IMPLIED
;;      WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A
;;      PARTICULAR PURPOSE. IN NO EVENT SHALL SUN MICROSYSTEMS,
;;      INC., USL OR BIGELOW & HOLMES BE LIABLE FOR ANY
;;      SPECIAL, INDIRECT, INCIDENTAL, OR CONSEQUENTIAL DAMAGES,
;;      OR ANY DAMAGES WHATSOEVER RESULTING FROM LOSS OF USE, DATA
;;      OR PROFITS, WHETHER IN AN ACTION OF  CONTRACT, NEGLIGENCE
;;      OR OTHER TORTIOUS ACTION, ARISING OUT OF OR IN CONNECTION
;;      WITH THE USE OR PERFORMANCE OF THIS OBJECT CODE.

(in-package :x11)

;;; This is a Lucid Common Lisp Foreign Function Interface for Xlib.  It was generated
;;; largely from a version of Xlib.h written by David Harrison of UC Berkeley in 1988 that
;;; included function prototype declarations for all of the Xlib exported functions.
;;;
;;; All of the C identifiers have been converted to Lisp style identifiers: embedded
;;; underscores have been converted to dashes and all characters have been (effectively)
;;; uppercased.  This led to one collision: the #defined constant Above collided with
;;; the slots called above in xconfigurerequestevent and xconfigureevent.  The Above
;;; constant was renamed "was-called-above"; its value is 0.
;;;
;;; The organization of this file should roughly follow the organization of Xlib.h (which
;;; #includes X.h).  Near the top of the file is a set of extensions and convienence
;;; functions that have been added locally.
;;;
;;; LOADING:
;;; This file depends on ffi.lisp. After ffi.lisp and this file load the X11 library:
;;; (FFI:load-foreign-libraries nil '("-X11" "-lm" "-lc")
;;;
;;; HISTORY:
;;; 4-1-89 - Hans Muller, hmuller@sun.COM, created.
;;;
;;; 5-30-89 - Hans Muller, hmuller@sun.COM, Now only export names without a leading
;;; underscore.  Export structure constructor, predicate, accessors.
;;;
;;; 11-20-89 - Hans Muller, hmuller@sun.COM. The drawing functions have been segregated
;;; and moved to the end of the file, :fixnum types have been substituted where possible.
;;; Added an XDrawChar function.  These changes yielded about an 8X speedup over
;;; the original definitions.
;;;
;;; 3-1-90 - Hans Muller, hmuller@sun.COM.  Appended definitions for the X11 resource
;;; manager from Xresource.h.
;;;
;;; BUGS:
;;; - Most of the C preprocessor macros where not translated.  A list of all of the
;;;   untranslated macros appears at the end of this file.  Most of them could
;;;   be translated into comparable Lisp macros.
;;;
;;; - Structure slots whose type is :pointer :pointer are probably C function pointers.
;;;   A synonym type should be used instead.
;;;
;;; - The translation of the union types should be checked.
;;;


(def-exported-foreign-synonym-type-cffi caddr-t :pointer)
(def-exported-foreign-synonym-type-cffi xid unsigned-long)
(def-exported-foreign-synonym-type-cffi window xid)
(def-exported-foreign-synonym-type-cffi font xid)
(def-exported-foreign-synonym-type-cffi pixmap xid)
(def-exported-foreign-synonym-type-cffi mask unsigned-long)
(def-exported-foreign-synonym-type-cffi atom unsigned-long)

(def-exported-foreign-synonym-type-cffi time unsigned-long)

(def-exported-foreign-struct-cffi xextdata
  (number :type int)
  (next :type (:pointer xextdata))
  (free-private :type (:pointer :pointer))
  (private-data :type (:pointer char)))


(def-exported-foreign-struct-cffi xkeyevent
  (type :type int)
  (serial :type unsigned-long)
  (send-event :type int)
  (display :type (:pointer display))
  (window :type window)
  (root :type window)
  (subwindow :type window)
  (time :type time)
  (x :type int)
  (y :type int)
  (x-root :type int)
  (y-root :type int)
  (state :type unsigned-int)
  (keycode :type unsigned-int)
  (same-screen :type int))
(def-exported-foreign-synonym-type-cffi xkeypressedevent xkeyevent)
(def-exported-foreign-synonym-type-cffi xkeyreleasedevent xkeyevent)


(def-exported-foreign-struct-cffi xbuttonevent
  (type :type int)
  (serial :type unsigned-long)
  (send-event :type int)
  (display :type (:pointer display))
  (window :type window)
  (root :type window)
  (subwindow :type window)
  (time :type time)
  (x :type int)
  (y :type int)
  (x-root :type int)
  (y-root :type int)
  (state :type unsigned-int)
  (button :type unsigned-int)
  (same-screen :type int))

(def-exported-foreign-synonym-type xbuttonpressedevent-cffi xbuttonevent)
(def-exported-foreign-synonym-type xbuttonreleasedevent-cffi xbuttonevent)



(def-exported-foreign-struct-cffi xmotionevent
  (type :type int)
  (serial :type unsigned-long)
  (send-event :type int)
  (display :type (:pointer display))
  (window :type window)
  (root :type window)
  (subwindow :type window)
  (time :type time)
  (x :type int)
  (y :type int)
  (x-root :type int)
  (y-root :type int)
  (state :type unsigned-int)
  (is-hint :type char)
  (same-screen :type int))

(def-exported-foreign-synonym-type-cffi xpointermovedevent xmotionevent)


(def-exported-foreign-struct-cffi xcharstruct
  (lbearing :type short)
  (rbearing :type short)
  (width :type short)
  (ascent :type short)
  (descent :type short)
  (attributes :type unsigned-short))

(def-exported-foreign-struct-cffi xfontprop
  (name :type atom)
  (card32 :type unsigned-long))

(def-exported-foreign-struct-cffi xfontstruct
  (ext-data :type (:pointer xextdata))
  (fid :type font)
  (direction :type unsigned)
  (min-char-or-byte2 :type unsigned)
  (max-char-or-byte2 :type unsigned)
  (min-byte1 :type unsigned)
  (max-byte1 :type unsigned)
  (all-chars-exist :type int)
  (default-char :type unsigned)
  (n-properties :type int)
  (properties :type (:pointer xfontprop))
  (min-bounds :type xcharstruct)
  (max-bounds :type xcharstruct)
  (per-char :type (:pointer xcharstruct))
  (ascent :type int)
  (descent :type int))

;;; ------------------------------------------------------------------

(def-exported-foreign-struct-cffi xtextitem
  (chars :type (:pointer char))
  (nchars :type int)
  (delta :type int)
  (font :type font))

(def-exported-foreign-struct-cffi xchar2b
  (byte1 :type unsigned-char)
  (byte2 :type unsigned-char))

(def-exported-foreign-struct-cffi xtextitem16
  (chars :type (:pointer xchar2b))
  (nchars :type int)
  (delta :type int)
  (font :type font))

(def-exported-foreign-struct-cffi xrmvalue
  (size :type unsigned-int)
  (addr :type caddr-t))

(def-exported-foreign-synonym-type-cffi xrmvalueptr (:pointer xrmvalue))
(def-exported-foreign-synonym-type-cffi XrmOptionKind int)

(def-exported-foreign-struct-cffi xrmoptiondescrec
  (option :type (:pointer char))
  (specifier :type (:pointer char))
  (argkind :type XrmOptionKind)
  (value :type caddr-t))

;;; Utility Definitions from Xutil.h

(def-exported-foreign-struct-cffi xwmhints
  (flags :type long)
  (input :type int)
  (initial-state :type int)
  (icon-pixmap :type pixmap)
  (icon-window :type window)
  (icon-x :type int)
  (icon-y :type int)
  (icon-mask :type pixmap)
  (window-group :type xid))

(def-exported-foreign-struct-cffi xsizehints
  (flags :type long)
  (x :type int)				; Obsolete
  (y :type int)				; Obsolete
  (width :type int)			; Obsolete
  (height :type int)			; Obsolete
  (min-width :type int)
  (min-height :type int)
  (max-width :type int)
  (max-height :type int)
  (width-inc :type int)
  (height-inc :type int)
  (min-aspect-x :type int)
  (min-aspect-y :type int)
  (max-aspect-x :type int)
  (max-aspect-y :type int)
  (base-width :type int)
  (base-height :type int)
  (win-gravity :type int))

(def-exported-foreign-synonym-type-cffi xcontext int)

(def-exported-foreign-struct-cffi xcomposestatus
  (compose-ptr :type (:pointer char))
  (chars-matched :type int))
