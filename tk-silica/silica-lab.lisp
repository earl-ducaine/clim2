(in-package :xm-silica)

(defparameter *graft* (find-graft :port *port*))
(defparameter *my-sheet* (make-instance 'motif-top-level-sheet))

(defun run-make-pane ()
  (make-pane 'push-button
	     :label "press me"
	     :background +black+
	     :activate-callback
	     (lambda (button)
	       (frame-exit *application-frame*))
	     :text-style
	     (make-text-style :serif :roman 20)))

(define-application-frame minimal-frame ()
  ()
  (:pane
   (vertically ()
     (make-clim-interactor-pane))))

(define-application-frame minimal-frame ()
  (:pane (make-pane-1 'basic-pane)))
  ;;  (vertically ())))
  ;;    (make-clim-interactor-pane))))


(clim:run-frame-top-level (clim:make-application-frame 'minimal-frame))

(defun make-anonymous-sheet ()
  (make-instance 'motif-top-level-sheet))


(defun make-anonymous-pane ()
  (enable-frame (pane-frame (open-window-stream))))

  ;; (defparameter *my-pane* (open-window-stream))
  ;; (size-frame-from-contents *my-pane* )
  ;; (position-sheet-carefully *my-pane* 50 50))

(defun run-sheet-adopt-child ()
  (sheet-adopt-child *graft* *my-pane*))

(defun run-enable-frame ()
    (defparameter my-frame (clim:make-application-frame 'minimal-frame))
    (enable-frame my-frame))
(enable-frame (pane-frame (open-window-stream)))

(defparameter *my-application-frame* nil)

(defun make-minimal-frame ()
  (setf *my-application-frame*
	(make-application-frame
	 'clim-internals::open-window-stream-frame
	 :enable t
	 :borders nil
	 :resize-frame t
	 :type  'application-pane
	 :scroll-bars :verticle
	 ;; scroll-bars nil
	 :frame-manager (find-frame-manager))))
  ;; (enable-frame *my-application-frame*)



;; One of the challanges of Silica is that the layers are difficult
;; for the developer to dicern.  For example, the sheet is the
;; fundamental unit of windowing.  Yet, one can not instantiate a
;; usable one directly, no can you ask the parents of sheets to create
;; one for you.  Instead, you must create a panel, which is a subtype
;; of sheet.  Something, again difficult to decern for the modern day
;; programmer.
;;
;; Another one, nothing can become visable without being associated with a frame, so for a sheet to be viewable it must be have been created of the subtype panel, and must have been associated with a frame.
