;;; -*- Mode: Lisp; Syntax: ANSI-Common-Lisp; Package: CLIM-UTILS; Base: 10; Lowercase: Yes -*-
;; See the file LICENSE for the full license governing this code.
;;

(in-package :clim-utils)

;;;"Copyright (c) 1990, 1991, 1992 Symbolics, Inc.  All rights reserved.
;;; Portions copyright (c) 1988, 1989, 1990 International Lisp Associates.
;;; Portions copyright (c) 1992, 1993 Franz, Inc."


;;; Locks

(eval-when (compile load eval)
  ;; (require :mdproc)
  ;; (require :process)
  )

(defvar *multiprocessing-p* t)

;;; This is to keep it quiet: On ACL it's safe to declare the
;;; predicate & args dynamic-extent on platforms with native threads
;;; *only*, which at present (6.0beta) is Windows platforms.
;;;
;;; the real definition of process-wait is in
;;; clim2:;aclpc;acl-clim.lisp.  That definition is almost certainly
;;; bogus because it misunderstands the whole way multithreading
;;; works: the definition above should be used instead.  But the
;;; Windows event-loop depends on this misunderstanding, and I don't
;;; want to change that.
;;;
;; #+(and allegro mswindows)
;; (excl:defun-proto process-wait (wait-reason predicate &rest args)
;;   (declare (dynamic-extent predicate args)))

;; -- I dont think we need this
;; #+Allegro
;; (unless (excl::scheduler-running-p)
;;   (mp:start-scheduler))

(defmacro with-lock-held ((place &optional state) &body forms)
  (declare (ignore state))
  `(bt:with-lock-held (,place) ,@forms))
  ;;   Lucid        `(lcl:with-process-lock (,place ,@(if state (cons state nil)))
  ;;                  ,@forms)
  ;;   lispworks        `(mp::with-lock (,place) ,@forms)
  ;;   Xerox        `(il:with.monitor ,place ,@forms)
  ;;   Cloe-Runtime `(progn ,@forms)
  ;;   aclpc       `(progn ,@forms)
  ;;   Genera        `(process:with-lock (,place) ,@forms)
  ;;   Minima        `(minima:with-lock (,place) ,@forms)
  ;;   CCL-2        `(progn ,@forms)
  ;;   }
  ;; )

(defun make-lock (&optional (lock-name "a CLIM lock"))
  (bt::make-lock lock-name))

;;; A lock that CAN be relocked by the same process.
;; (defmacro with-simple-recursive-lock ((lock &optional (state "Unlock")) &body forms)
;;   `(flet ((foo () ,@forms))
;;      (declare (dynamic-extent #'foo))
;;      (invoke-with-simple-recursive-lock ,lock ,state #'foo)))

;; (defun invoke-with-simple-recursive-lock (place state continuation)
;;   (let ((store-value (current-process))
;;         (place-value (first place)))
;;     (if (and place-value (eql place-value store-value))
;;         (funcall continuation)
;;         (progn
;;           (unless (null place-value)
;;             (flet ((waiter ()
;;                      (null (first place))))
;;               #-allegro (declare (dynamic-extent #'waiter))
;;               (process-wait state #'waiter)))
;;           (unwind-protect
;;               (progn (rplaca place store-value)
;;                      (funcall continuation))
;;             (rplaca place nil))))))

(defmacro with-recursive-lock-held ((place &optional state) &body forms)
  (declare (ignore state))
  `(bt:with-recursive-lock-held (,place) ,@forms))


(defun make-recursive-lock (&optional (lock-name "a recursive CLIM lock"))
  (declare (ignore lock-name))
  (bt:make-recursive-lock lock-name))

;;; Atomic operations

(defmacro without-scheduling (&body forms)
  "Evaluate the forms w/o letting any other process run."
  #+allegro `(excl:with-delayed-interrupts ,@forms)
  #+sbcl  `(sbcl:without-scheduling ,@forms))

;; Atomically increments a fixnum value
;; #+Genera
;; (defmacro atomic-incf (reference &optional (delta 1))
;;   (let ((location '#:location)
;;         (old-value '#:old)
;;         (new-value '#:new))
;;     `(loop with ,location = (scl:locf ,reference)
;;            for ,old-value = (scl:location-contents ,location)
;;            for ,new-value = (sys:%32-bit-plus ,old-value ,delta)
;;            do (when (scl:store-conditional ,location ,old-value ,new-value)
;;                 (return ,new-value)))))


(defmacro atomic-incf (reference &optional (delta 1))
  (let ((value '#:value))
    (if (= delta 1)
        `(without-scheduling
           (let ((,value ,reference))
             (if (eq ,value most-positive-fixnum)
                 (setf ,reference most-negative-fixnum)
	       (setf ,reference (the fixnum (1+ (the fixnum ,value)))))))
      #+ignore (warn "Implement ~S for the case when delta is not 1" 'atomic-incf)
      #-ignore ;; maybe?
      (if (< delta 0)
	  `(without-scheduling
	     (let ((,value ,reference))
	       (if (< ,delta (- ,value most-negative-fixnum))
		   (setf ,reference most-positive-fixnum)
		 (setf ,reference (the fixnum (+ (the fixnum ,delta) (the fixnum ,value)))))))
	`(without-scheduling
	   (let ((,value ,reference))
	     (if (> ,delta (- most-positive-fixnum ,value))
		 (setf ,reference most-negative-fixnum)
	       (setf ,reference (the fixnum (+ (the fixnum ,delta) (the fixnum ,value))))))))
      )))

;; Atomically decrements a fixnum value
;; #+Genera
;; (defmacro atomic-decf (reference &optional (delta 1))
;;   (let ((location '#:location)
;;         (old-value '#:old)
;;         (new-value '#:new))
;;     `(loop with ,location = (scl:locf ,reference)
;;            for ,old-value = (scl:location-contents ,location)
;;            for ,new-value = (sys:%32-bit-difference ,old-value ,delta)
;;            do (when (scl:store-conditional ,location ,old-value ,new-value)
;;                 (return ,new-value)))))

(defmacro atomic-decf (reference &optional (delta 1))
  (let ((value '#:value))
    (if (= delta 1)
        `(without-scheduling
           (let ((,value ,reference))
             (if (eq ,value most-negative-fixnum)
                 (setf ,reference most-positive-fixnum)
                 (setf ,reference (the fixnum (1- (the fixnum ,value)))))))
        (warn "Implement ~S for the case when delta is not 1" 'atomic-decf))))

;;; Processes (note, what are called processes here are really threads
;;; in mosts modern lisps)

(defun make-process (function &key name)
  (bt:make-thread function name))

(defun processp (object)
  (bt::thread-p object))

;; Not safe in most environments
(defun destroy-process (process)
  allegro    (bt:destroy-thread  process))


(defun current-process ()
  (bt:current-thread))

(defun all-processes ()
  (bt:all-threads))

;; ???
(defun show-processes ()
  (all-processes))

(defun process-yield ()
  (bt:thread-yield))

(defun process-wait (wait-reason predicate)
  "Cause the current process to go to sleep until the predicate returns TRUE."
  #+allegro (mp:process-wait wait-reason predicate)
  #+sbcl (bt:condition-wait predicate wait-reason))

(defun process-wait-with-timeout (wait-reason timeout predicate)
  "Cause the current process to go to sleep until the predicate returns TRUE or
   timeout seconds have gone by."
  (when (null timeout)
    ;; ensure genera semantics, timeout = NIL means indefinite timeout
    (return-from process-wait-with-timeout
      (process-wait wait-reason predicate)))
  #+sbcl (bt:condition-wait predicate wait-reason :timeout timeout)
  #+allegro (mp:process-wait-with-timeout wait-reason timeout predicate))


;; dangerous
(defun process-interrupt (process function)
  (bt:interrupt-thread process function))

(defun restart-process (process)
  #+allegro (mp:process-reset process)
  #+sbcl (sb-thread:process-reset process))

(defun enable-process (process)
  #+allegro (mp:process-enable process)
  #+sbcl  (bt:process-enable process))

(defun disable-process (process)
  #+allegro (mp:process-disable process)
  #+sbcl (bt:process-disable process))

(defun process-name (process)
  (bt:thread-name process))

(defun process-state (process)
  (cond ((bt:thread-alive-p process) "active")
	(t "deactivated")))

(defun process-whostate (process)
  #+allegro (mp:process-whostate process)
  #+sbcl (bt:process-whostate process))
