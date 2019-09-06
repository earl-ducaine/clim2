;; See the file LICENSE for the full license governing this code.

;; This file contains compile time only code -- put in clim-debug.fasl.

(in-package :tk)

;;; Foreign Structure Constructors

;; This is here to limit need for ff package to compile time.
(defun system-free (x)
  (excl:free x))

(defun allocate-memory (size init)
  ;; Used only by allocate-cstruct.
  (let ((pointer (excl:malloc size)))
    (when init
      (do ((i 0 (+ i #-64bit 4 #+64bit 8)))
	  ((>= i size))
	(declare (fixnum i))
	(setf (sys:memref-int pointer i 0 :unsigned-natural) 0)))
    pointer))

;;; allocate-cstruct was adapted from ff-wrapper::make-cstruct.  We aren't
;;; using ff-wrapper::make-cstruct because it uses excl:aclmalloc.
;; (defun allocate-cstruct (name &key
;; 			      (number 1)
;; 			      (initialize
;; 			       (ff-wrapper::cstruct-property-initialize
;; 				(ff-wrapper::cstruct-prop name)))
;; 			      )
;;   (declare (optimize (speed 3)))
;;   (let* ((prop (ff-wrapper::cstruct-prop name))
;; 	 (size (* number (ff-wrapper::cstruct-property-length prop))))
;;     (when initialize
;;       (setq initialize 0))
;;     (allocate-memory size initialize)))

;;; allocate-cstruct was adapted from ff-wrapper::make-cstruct.  We aren't
;;; using ff-wrapper::make-cstruct because it uses excl:aclmalloc.

#+use-cffi
(defun allocate-cstruct (name &key
			      (number 1)
				initialize)
  (declare (ignor (number initialize)))
  (cffi:foreign-alloc name :count number))

#-use-cffi
(defun allocate-cstruct (name &key
			      (number 1)
			      (initialize
			       (ff-wrapper::cstruct-property-initialize
				(ff-wrapper::cstruct-prop name))))
  (let* ((prop (ff-wrapper::cstruct-prop name))
	 (size (* number (ff-wrapper::cstruct-property-length prop))))
    (when initialize
      (setq initialize 0))
    (allocate-memory size initialize)))

;;; We aren't using excl:string-to-native by default because it uses
;;; excl:aclmalloc.
;;; aclmalloc is bad because Motif tries to free certain values
;;; itself, and will then crash and burn if they were allocated with
;;; aclmalloc.
;; This now uses the slightly slower (locale-correct) way of
;; converting to octets first, then copying to foreign space.
(defun string-to-foreign (string &optional address)
  "Convert a Lisp string to a C string, by copying."
  (declare (optimize (speed 3))
                (type string string)
                (type integer address))
  (unless (stringp string)
    (excl::.type-error string 'string))
  (if address
      (excl:string-to-native string :address address)
      (let* ((octets (excl:string-to-octets string :null-terminate t))
             (length (length octets)))
        (declare (optimize (safety 0))
                      (type fixnum length))
        (setf address (excl:malloc length))
        (dotimes (i length)
          (declare (fixnum i))
          (setf (sys:memref-int address 0 i :unsigned-byte)
                (aref octets i)))
        #+clim-utils::extra-careful(let ((re-char-ed (excl:octets-to-string octets)))
          (assert (equal re-char-ed string)
                  (re-char-ed string)
                  "string isn't equal to re-chared octets~%~S~%~S!" string re-char-ed))))
  #+clim-utils::extra-careful(let ((re-lisped (excl:native-to-string address)))
    (assert (equal re-lisped string)
            (re-lisped string)
            "string isn't equal to re-chared foreign mem ~%~S~%~S!" string re-lisped))
  address)


(ff-wrapper::def-c-typedef :cardinal :unsigned-int)
(ff-wrapper::def-c-typedef xt-proc * :unsigned-long)
(ff-wrapper::def-c-typedef action-list * :char)
(ff-wrapper::def-c-typedef resource-list * :char)
(ff-wrapper::def-c-typedef xrm-quark :int)
(ff-wrapper::def-c-typedef xrm-quark-list * :int)
(ff-wrapper::def-c-typedef boolean :char)
(ff-wrapper::def-c-typedef xrm-class  xrm-quark)
(ff-wrapper::def-c-typedef xt-enum   :unsigned-char)
(ff-wrapper::def-c-typedef xt-version-type :long)
(def-c-typedef xt-geometry-mask :unsigned-int)
(def-c-typedef xt-position :short)
(def-c-typedef xt-dimension :unsigned-short)
(ff-wrapper::def-c-typedef xt-pointer * char)

(ff-wrapper::def-c-type (xt-class :no-defuns :no-constructor) :struct
	    (superclass :long)
	    (name * :char)
	    (widget-size :cardinal)
	    (class-initialize xt-proc)
	    (class-part-initialize xt-proc)
	    (inited xt-enum)
	    (initialize xt-proc)
	    (initialize-hook xt-proc)
	    (realize xt-proc)
	    (actions action-list)
	    (num-actions :cardinal)
	    (resources resource-list)
	    (num-resources :cardinal)
	    (xrm-class xrm-class)
	    (compress-motion boolean)
	    (compress-exposure xt-enum)
	    (compress-enter-leave boolean)
	    (visible-interest boolean)
	    (destroy xt-proc)
	    (resize xt-proc)
	    (expose xt-proc)
	    (set-values xt-proc)
	    (set-values-hook xt-proc)
	    (set-values-almost xt-proc)
	    (get-values-hook xt-proc)
	    (accept-focus xt-proc)
	    (version xt-version-type)
	    (callback-private * :char))

(ff-wrapper::def-c-type (xt-resource :no-defuns :no-constructor) :struct
  (name * :char)
  (class * :char)
  (type * :char)
  (size :cardinal)
  (offset :cardinal)
  (default-type * :char)
  (default-addr * :char)
  )

;; Horrible internal stuff

(ff-wrapper::def-c-type (xt-offset-rec :no-defuns :no-constructor) :struct
	    (next * :char)
	    (name xrm-quark)
	    (offset :int))

(defun import-offset-list (x)
  (let ((r nil))
    (do ((x x (xt-offset-rec-next x)))
	((zerop x)
	 (nreverse r))
      (push (list (xt-offset-rec-name x)
		  (xt-offset-rec-offset x)) r))))

(ff-wrapper::def-c-type (xt-widget :no-defuns :no-constructor) :struct
  (self :unsigned-long)
  (widget-class :unsigned-long))

;; (def-c-type (xt-widget :no-defuns :no-constructor) :struct
;;   (self :unsigned-long)
;;   (widget-class :unsigned-long))

(ff-wrapper::def-c-type (xt-resource-list :in-foreign-space :no-defuns :no-constructor) 1 xt-resource)

(ff-wrapper::def-c-type (x-push-button-callback-struct :no-defuns :no-constructor) :struct
  (reason :int)
  (event * x11:xevent)
  (click-count :int))

(ff-wrapper::def-c-type (x-drawing-area-callback :no-defuns :no-constructor) :struct
  (reason :int)
  (event * x11:xevent)
  (window x11:window))

(ff-wrapper::def-c-type (xcharstruct-vector :no-defuns :no-constructor) 1 x11:xcharstruct)

(ff-wrapper::def-c-type (xfontname-list :no-defuns :no-constructor) 1 * :char)

(ff-wrapper::def-c-type (xfontstruct-array :no-defuns :no-constructor) 1 x11::xfontstruct)

(ff-wrapper::def-c-type (class-array :no-defuns :no-constructor) 1 :unsigned-long)

(ff-wrapper::def-c-type (xt-arg-val :no-defuns :no-constructor) :long)

(ff-wrapper::def-c-type (xt-arg :in-foreign-space :no-defuns :no-constructor) :struct
  (name  * :char)
  (value xt-arg-val))

(ff-wrapper::def-c-type (xt-arglist :in-foreign-space :no-defuns :no-constructor) 1 xt-arg)

(ff-wrapper::def-c-type (xt-widget-list :no-defuns :no-constructor) 1 * xt-widget)

(ff-wrapper::def-c-type (xt-widget-geometry :no-defuns :no-constructor) :struct
  (request-mode xt-geometry-mask)
  (x xt-position)
  (y xt-position)
  (width xt-dimension)
  (height xt-dimension)
  (border-width xt-dimension)
  (sibling xt-widget)
  (stack-mode :int))

;; general pointer-array

;;(ff-wrapper::def-c-type (pointer-array :no-defuns :no-constructor) 1 * char)

(x11::def-exported-constant lc-ctype 0)
(x11::def-exported-constant lc-all 6)
