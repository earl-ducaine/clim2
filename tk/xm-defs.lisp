;; See the file LICENSE for the full license governing this code.

;; This file contains compile time only code -- put in clim-debug.fasl.


(in-package :tk)

(ff-wrapper::def-c-typedef xm-string :int)
(ff-wrapper::def-c-typedef xm-text-position :long)

(ff-wrapper::def-c-type (xm-text-block-rec :no-defuns) :struct
	    (ptr * :char)
	    (length :int)
	    (format x11:atom))

(ff-wrapper::def-c-typedef xm-text-block * xm-text-block-rec)

(ff-wrapper::def-c-type (xm-text-field-callback-struct :no-defuns :no-constructor) :struct
	    (reason :int)
	    (event * x11:xevent)
	    (doit boolean)
	    (curr-insert xm-text-position)
	    (new-insert xm-text-position)
	    (start-pos xm-text-position)
	    (end-pos xm-text-position)
	    (text xm-text-block))

(ff-wrapper::def-c-type (xm-file-selection-box-callback-struct :no-defuns :no-constructor) :struct
	    (reason :int)
	    (event * x11:xevent)
	    (value xm-string) ;; xmstring
	    (length :int)
	    (mask xm-string)
	    (mask-length :int)
	    (dir xm-string)
	    (dir-length :int)
	    (pattern xm-string)
	    (pattern-length xm-string))

(ff-wrapper::def-c-type (xm-list-callback-struct :no-defuns :no-constructor) :struct
            (reason :int)
            (event * x11:xevent)
            (item * :void)  ; xm-string (spr 30640; alemmens, 2005-11-30)
            (item-length :int)
            (item-position :int)
            (selection-items * xm-string)
            (selected-item-count :int)
            (selected-item-positions * :int)
            (selection-type :int))


(ff-wrapper::def-c-type (xm-selected-position-array :no-defuns :no-constructor) 1 :int)

(ff-wrapper::def-c-type (xm-string-table :no-defuns :no-constructor) 1 * :char)

;;; string constants from Xm.h
(x11::def-exported-constant XmRColormap		"Colormap")
(x11::def-exported-constant XmRVisual		"Visual")
(x11::def-exported-constant XmRInt		"Int")

(x11::def-exported-constant XmMULTIBYTE_TEXT    1)
(x11::def-exported-constant XmOUTPUT_ALL        0)
