;; See the file LICENSE for the full license governing this code.

;; This file contains compile time only code -- put in clim-debug.fasl.


(in-package :tk)

;; (ff:def-c-type (alisp-xm-proto-callback-info :in-foreign-space :no-defuns :no-constructor) :struct
;;   (handle :int)
;;   (data :int))

;; (ff:def-c-type (alisp-xm-protocol :no-defuns :no-constructor) :struct
;;   (object * :char)
;;   (ext * :char)
;;   (protocol * :char))

;; (ff:def-c-typedef alisp-xm-string :int)
;; (ff:def-c-typedef alisp-xm-text-position :long)

;; (ff:def-c-type (alisp-xm-text-block-rec :no-defuns) :struct
;;   (ptr * :char)
;;   (length :int)
;;   (format x11:atom))

;; (ff:def-c-typedef alisp-xm-text-block * xm-text-block-rec)

;; (ff:def-c-atype (alisp-xm-text-field-callback-struct :no-defuns :no-constructor) :struct
;;   (reason :int)
;;   (event * x11:xevent)
;;   (doit boolean)
;;   (curr-insert xm-text-position)
;;   (new-insert xm-text-position)
;;   (start-pos xm-text-position)
;;   (end-pos xm-text-position)
;;   (text xm-text-block))

;; (def-c-type (xm-file-selection-box-callback-struct :no-defuns :no-constructor) :struct
;;   (reason :int)
;;   (event * x11:xevent)
;;   (value xm-string) ;; xmstring
;;   (length :int)
;;   (mask xm-string)
;;   (mask-length :int)
;;   (dir xm-string)
;;   (dir-length :int)
;;   (pattern xm-string)
;;   (pattern-length xm-string))

;; (def-c-type (xm-list-callback-struct :no-defuns :no-constructor) :struct
;;   (reason :int)
;;   (event * x11:xevent)
;;   (item * :void)  ; xm-string (spr 30640; alemmens, 2005-11-30)
;;   (item-length :int)
;;   (item-position :int)
;;   (selection-items * xm-string)
;;   (selected-item-count :int)
;;   (selected-item-positions * :int)
;;   (selection-type :int))


;; (def-c-type (xm-selected-position-array :no-defuns :no-constructor) 1 :int)

;; (def-c-type (xm-string-table :no-defuns :no-constructor) 1 * :char)

;; (defparameter XmRColormap alisp-XmRColormap)
;; (defparameter XmRVisual	alisp-XmRVisual)
;; (defparameter XmRInt alisp-XmRInt)
;; (defparameter XmMULTIBYTE_TEXT alisp-XmMULTIBYTE_TEXT)
;; (defparameter XmOUTPUT_ALL alisp-XmOUTPUT_ALL)
