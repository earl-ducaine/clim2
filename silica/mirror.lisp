;;; -*- Mode: Lisp; Syntax: ANSI-Common-Lisp; Package: SILICA; Base: 10; Lowercase: Yes -*-

;; $fiHeader: mirror.lisp,v 1.25 92/09/08 15:16:47 cer Exp Locker: cer $

(in-package :silica)

"Copyright (c) 1991, 1992 Franz, Inc.  All rights reserved.
 Portions copyright (c) 1992 Symbolics, Inc.  All rights reserved."


;;;; sheet-device-transformation - transformation from sheets
;;;; coordinate space to its mirror

;;;; sheet-device-region - clipping region in mirror coordinate space

;;; Mirrors

(defgeneric sheet-mirror (sheet))
(defgeneric sheet-direct-mirror (sheet))

(defgeneric sheet-native-transformation (sheet))
(defgeneric sheet-native-region (sheet))
(defgeneric sheet-native-region* (sheet))
(defgeneric sheet-device-region (sheet))

(defgeneric realize-mirror (port sheet))
(defgeneric destroy-mirror (port sheet))
(defgeneric enable-mirror  (port sheet))
(defgeneric disable-mirror (port sheet))

(defmethod sheet-direct-mirror ((sheet sheet)) nil)


(defclass mirrored-sheet-mixin ()
    ((mirror :initform nil :accessor sheet-direct-mirror)
     (native-transformation :initform +identity-transformation+
			    :accessor sheet-native-transformation)))

;;; Native transformation

;;--- This should be cached so that it doesn't cons...
(defmethod sheet-native-transformation ((sheet sheet))
  (compose-transformations 
    (sheet-transformation sheet)
    (sheet-native-transformation (sheet-parent sheet))))

;;; Device-transformation
;;; transformation from a sheets coordinate space to the coordinate
;;; space of the mirror

(defgeneric sheet-device-transformation (sheet))

(defmethod sheet-device-transformation ((sheet sheet))
  (compose-transformations
    (sheet-transformation sheet)
    (sheet-device-transformation (sheet-parent sheet))))

(defmethod sheet-device-transformation ((sheet sheet-transformation-mixin))
  (or (sheet-cached-device-transformation sheet)
      (setf (sheet-cached-device-transformation sheet)
	    (compose-transformations
	      (sheet-transformation sheet)
	      (sheet-device-transformation (sheet-parent sheet))))))

(defmethod sheet-device-transformation :around ((sheet mirrored-sheet-mixin))
  (if (sheet-direct-mirror sheet)
      (sheet-native-transformation sheet)
      (call-next-method)))

;;; Native region

(defmethod sheet-native-region ((sheet mirrored-sheet-mixin))
  (transform-region
    (sheet-native-transformation sheet)
    (sheet-region sheet)))

(defmethod sheet-native-region* ((sheet mirrored-sheet-mixin))
  (with-bounding-rectangle* (minx miny maxx maxy) (sheet-region sheet)
    (transform-rectangle*
      (sheet-native-transformation sheet)
      minx miny maxx maxy)))

;;; Device region
  

(defmethod sheet-device-region ((sheet mirrored-sheet-mixin))
  (sheet-native-region sheet))

(defmethod sheet-device-region ((sheet sheet))
  (region-intersection
    (transform-region 
      (sheet-device-transformation sheet)
      (sheet-region sheet))
    (sheet-device-region (sheet-parent sheet))))

;;--- This assumes that sheet siblings do not overlap
(defmethod sheet-device-region ((sheet sheet-transformation-mixin))
  (let ((region (sheet-cached-device-region sheet)))
    ;; We decache the device region by setting this slot to NIL...
    (cond ((or (eq region +nowhere+)		;it can happen
	       (and region (slot-value region 'left)))
	   region)
	  (region
	   ;; Be very careful not to cons.  It's worth all this hair
	   ;; because common operations such as scrolling invalidate 
	   ;; this cache all the time.
	   (with-bounding-rectangle* (left top right bottom) 
	       (sheet-region sheet)
	     (multiple-value-bind (pleft ptop pright pbottom) 
		 (let ((region (sheet-device-region (sheet-parent sheet))))
		   (if (eq region +nowhere+)
		       (values 0 0 0 0)
		       (bounding-rectangle* region)))
	       (multiple-value-bind (valid left top right bottom)
		   (multiple-value-call #'ltrb-overlaps-ltrb-p
		     (transform-rectangle*
		       (sheet-device-transformation sheet) left top right bottom)
		     pleft ptop pright pbottom)
		 (cond (valid
			(setf (slot-value region 'left) left
			      (slot-value region 'top)  top
			      (slot-value region 'right)  right
			      (slot-value region 'bottom) bottom)
			region)
		       (t
			(setf (sheet-cached-device-region sheet) +nowhere+)))))))
	  (t
	   (setf (sheet-cached-device-region sheet)
		 (region-intersection
		   (transform-region 
		     (sheet-device-transformation sheet)
		     (sheet-region sheet))
		   (sheet-device-region (sheet-parent sheet))))))))

;;;; Mirror region stuff


(defmethod sheet-actual-native-edges* ((sheet sheet))
  ;; Returns the sheet-region in the parents native coordinate space
  (let* ((region (sheet-region sheet))
	 (sheet-to-parent (sheet-transformation sheet))
	 (parent (sheet-parent sheet))
	 (parent-to-native (sheet-device-transformation parent)))
    (with-bounding-rectangle* (left top right bottom)
	(transform-region 
	  parent-to-native
	  (transform-region sheet-to-parent region))
      (values left top right bottom))))

;; Returns the regions mirror in the mirror coordinate space
(defgeneric mirror-region (port sheet))
(defgeneric mirror-native-edges* (port sheet))
(defgeneric mirror-inside-edges* (port sheet))
(defgeneric set-sheet-mirror-edges* (port sheet left top right bottom))

(defmethod mirror-region ((port basic-port) sheet)
  (multiple-value-call #'make-bounding-rectangle
    (mirror-region* port sheet)))

;; Returns the mirror's region in its parents coordinate space
(defgeneric mirror-edges* (port sheet))

;; Sets the mirror's region in its parents coordinate space
(defgeneric set-mirror-edges* (port sheet minx miny maxx maxy))

(defmethod mirror-origin ((port basic-port) (sheet sheet))
  :nw)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;



(defmethod sheet-mirror ((sheet sheet))
  (sheet-direct-mirror
    (sheet-mirrored-ancestor sheet)))

(defgeneric sheet-mirrored-ancestor (sheet))
(defmethod sheet-mirrored-ancestor ((sheet sheet))
  (cond ((sheet-direct-mirror sheet)
	 sheet)
	((null (sheet-parent sheet))
	 (error "Error in sheet mirrored ancestor: ~S"
		sheet))
	(t
	 (sheet-mirrored-ancestor
	   (sheet-parent sheet)))))

(defun-inline mirror->sheet (port mirror)
  (gethash mirror (port-mirror->sheet-table port)))

#-(or Genera Minima)			;inlining the function is enough...
(defun (setf mirror->sheet) (sheet port mirror)
  (setf (gethash mirror (port-mirror->sheet-table port)) sheet))

(defmethod realize-mirror :around ((port basic-port) (sheet mirrored-sheet-mixin))
  (let ((mirror
	  (or (sheet-direct-mirror sheet)
	      (setf (sheet-direct-mirror sheet)
		    (call-next-method)))))
    (setf (mirror->sheet port mirror) sheet)
    ;;--- What is the right thing do here?
    ;;--- In the Motif port we note specify the width and height of
    ;;--- widgets when we make them.  We rely on the layout protocol
    ;;--- to take care of all of that, ie. to go in and change the size
    #+++ignore (update-mirror-transformation port sheet)
    #---ignore (setf (sheet-native-transformation sheet) +identity-transformation+)
    mirror))

(defmethod destroy-mirror :around ((port basic-port) (sheet mirrored-sheet-mixin))
  (call-next-method)
  (setf (sheet-direct-mirror sheet) nil))

(defmethod note-sheet-grafted :after ((sheet mirrored-sheet-mixin))
  (realize-mirror (port sheet) sheet))

(defmethod note-sheet-degrafted :after ((sheet mirrored-sheet-mixin))
  (when (sheet-direct-mirror sheet)
    (destroy-mirror (port sheet) sheet)))

(defmethod note-sheet-enabled ((sheet mirrored-sheet-mixin))
  (call-next-method)
  (when (sheet-direct-mirror sheet)
    (enable-mirror (port sheet) sheet)))

(defmethod note-sheet-disabled ((sheet mirrored-sheet-mixin))
  (call-next-method)
  (when (sheet-direct-mirror sheet)
    (disable-mirror (port sheet) sheet)))

;; This code makes sure that enabling/disabling a non mirrored sheet
;; actually causes something to happen.
(defun update-sheet-mirrored-children (sheet state)
  (when (typep sheet '(and sheet-parent-mixin (not mirrored-sheet-mixin)))
    (dolist (child (sheet-children sheet))
      (when (sheet-enabled-p child)
	(if (typep child 'mirrored-sheet-mixin)
	    (if (sheet-direct-mirror child)
		(funcall (if state #'enable-mirror #'disable-mirror) (port child) child))
	    (update-sheet-mirrored-children child state))))))

(defmethod note-sheet-enabled :after ((sheet sheet-parent-mixin))
  (update-sheet-mirrored-children sheet t))

(defmethod note-sheet-disabled :after ((sheet sheet-parent-mixin))
  (update-sheet-mirrored-children sheet nil))


;; We need this because if we change a transformation, the sheet gets moved
(defmethod invalidate-cached-transformations :after ((sheet mirrored-sheet-mixin))
  (when (sheet-direct-mirror sheet)
    (update-mirror-region (port sheet) sheet)))

;; There is not an INVALIDATE-CACHED-REGION method because the only
;; time the region changes is when we change it directly, but we do
;; need this method.
(defmethod note-sheet-region-changed :after ((sheet mirrored-sheet-mixin) 
					     &key port-did-it)
  (when (sheet-direct-mirror sheet)
    (unless port-did-it
      (update-mirror-region (port sheet) sheet))))

(defun sheet-top-level-mirror (sheet)
  (let ((mirror nil))
    (loop
      (when (graftp sheet)
	(return mirror))
      (when (sheet-direct-mirror sheet) 
	(setq mirror sheet))
      (setq sheet (sheet-parent sheet)))))

;;; There is some confusion here about mirror-inside-edges*
;;; This actual returns coordinates in the mirrors parents space
;;; rather than

(defmethod update-mirror-region ((port basic-port) (sheet mirrored-sheet-mixin))
  ;; If the sheet-region is changed this updates the mirrors region accordingly
  (update-mirror-region-1 port sheet (sheet-parent sheet)))
  
(defmethod update-mirror-region-1 ((port basic-port) sheet parent)
  (declare (ignore parent))
  ;; Coordinates in parent space
  (multiple-value-bind (target-left target-top target-right target-bottom)
      (sheet-actual-native-edges* sheet)
    (multiple-value-bind (actual-left actual-top actual-right actual-bottom)
	(mirror-native-edges* (port sheet) sheet)
      (set-sheet-mirror-edges*
	(port sheet) sheet
	target-left target-top target-right target-bottom)))
  (update-mirror-transformation port sheet))

(defmethod update-mirror-transformation ((port basic-port) (sheet mirrored-sheet-mixin))
  ;; Compute transformation from sheet-region to mirror cordinates.
  (update-mirror-transformation-1 port sheet (sheet-parent sheet)))

#-scale-mirror
;; SHEET will be a mirrored sheet, and PARENT will often be the graft
(defmethod update-mirror-transformation-1 ((port basic-port) sheet parent)
  (declare (ignore parent))
  (multiple-value-bind (mirror-left mirror-top mirror-right mirror-bottom)
      (mirror-inside-edges* port sheet)
    (declare (ignore mirror-right mirror-bottom))
    (with-bounding-rectangle* (left top right bottom) (sheet-region sheet)
      (declare (ignore right bottom))
      (let ((tr-x (- mirror-left left))
	    (tr-y (- mirror-top top)))
	;; Really no point in using volatile transformations since 
	;; (1) this doesn't happen much, and (2) it's almost always
	;; the identity transformation
	(setf (sheet-native-transformation sheet)
	      (make-translation-transformation tr-x tr-y))))))

#+scale-mirror
(defvar *check-mirror-transformation* nil)

;; SHEET will be a mirrored sheet, and PARENT will often be the graft
#+scale-mirror
(defmethod update-mirror-transformation-1 ((port basic-port) sheet parent)
  (declare (ignore parent))
  (multiple-value-bind (mirror-left mirror-top mirror-right mirror-bottom)
      (mirror-inside-edges* port sheet)
    (with-bounding-rectangle* (left top right bottom) (sheet-region sheet)
      (let ((tr-x (- mirror-left left))
	    (tr-y (- mirror-top top))
	    (sc-x (/ (- mirror-right mirror-left)
		     (- right left)))
	    (sc-y (/ (- mirror-bottom mirror-top)
		     (- bottom top))))
	;; Only scale to the nearest hundredth...
	(setq sc-x (/ (floor (+ (* sc-x 100) 0.5)) 100))
	(setq sc-y (/ (floor (+ (* sc-y 100) 0.5)) 100))
	;; Usually the translation will be (0,0) and the scaling will be (1,1),
	;; meaning that the result will be the identity transformation
	(when (and *check-mirror-transformation*
		   (or (> (abs (- sc-x 1.0)) 0.01)
		       (> (abs (- sc-y 1.0)) 0.01)
		       (not (zerop tr-x))
		       (not (zerop tr-y))))
	  (let (#+Allegro (*error-output* excl::*initial-terminal-io*))
	    (warn "Mirror scaling ~S,~S,~S,~S" 
		  (list tr-x tr-y sc-x sc-y) sheet
		  (multiple-value-list (mirror-inside-edges* port sheet))
		  (sheet-region sheet))))
	;; Really no point in using volatile transformations since 
	;; (1) this doesn't happen much, and (2) the result is almost
	;; always the identity transformation
	(setf (sheet-native-transformation sheet)
	      (compose-transformations
		(make-translation-transformation tr-x tr-y)
		(make-scaling-transformation sc-x sc-y)))))))

;;; Mirror region protocol

;; Returns the coordinates of sheet's mirror in the coordinates of the
;; parent of the mirror
(defgeneric mirror-region* (port sheet)
  (declare (values left top right bottom)))

;; Returns the coordinates of sheet's mirror in the coordinates of the
;; mirror itself.  That is, it will return 0,0,WIDTH,HEIGHT for most
;; known window systems
(defgeneric mirror-inside-region* (port sheet)
  (declare (values left top right bottom)))

;; There also seems to be a need for a mirrors region in the
;; (sheet-mirror (sheet-parent sheet)) coordinate system
;; ie. the mirors parent is something not known to CLIM

(defgeneric set-mirror-region* (port sheet minx miny maxx maxy))

(defmethod mirror-region-updated ((port basic-port) (sheet mirrored-sheet-mixin))
  (let* ((region (sheet-region sheet))
	 (parent (sheet-parent sheet))
	 (sheet-to-parent (sheet-transformation sheet))
	 (parent-to-native (sheet-native-transformation parent))
	 (region-changed-p nil)
	 (transformation-changed-p nil))
    ;; Sheet in parent space
    (multiple-value-bind (ominx ominy omaxx omaxy)
	(multiple-value-call #'transform-rectangle* 
			     sheet-to-parent (bounding-rectangle* region))
      ;; Mirror in parents coord space
      (multiple-value-bind (nminx nminy nmaxx nmaxy)
	  (multiple-value-call #'untransform-rectangle*
			       parent-to-native (mirror-region* port sheet))
	(let ((dx (- nminx ominx))
	      (dy (- nminy ominy)))
	  (unless (and (zerop dx)
		       (zerop dy))
	    (setq sheet-to-parent (compose-translation-with-transformation
				    sheet-to-parent dx dy)
		  transformation-changed-p t)))
	;; If the width/height have changed then the region has changed
	(let* ((owidth (- omaxx ominx))
	       (oheight (- omaxy ominy))
	       (nwidth (- nmaxx nminx))
	       (nheight (- nmaxy nminy))
	       (dw (- nwidth owidth))
	       (dh (- nheight oheight)))
	  (unless (and (zerop dw)
		       (zerop dh))
	    (multiple-value-bind (nw nh)
		(untransform-distance sheet-to-parent nwidth nheight)
	      ;; This could clobber the region, but it's not worth it
	      (setf region 
		    (with-bounding-rectangle* (left top right bottom) region
		      (declare (ignore right bottom))
		      (make-bounding-rectangle left top 
					       (+ left nw) (+ top nh)))
		    region-changed-p t))))
	(when transformation-changed-p
	  (setf (slot-value sheet 'transformation) sheet-to-parent))
	(when region-changed-p
	  (setf (slot-value sheet 'region) region))
	(when (or transformation-changed-p region-changed-p)
	  (update-mirror-transformation port sheet))
	(when region-changed-p
	  (note-sheet-region-changed sheet :port-did-it t))
	(when transformation-changed-p
	  (note-sheet-transformation-changed sheet :port-did-it t))))))

(defmethod handle-event ((sheet mirrored-sheet-mixin)
			 (event window-configuration-event))
  (mirror-region-updated (port sheet) sheet)
  (deallocate-event event))
