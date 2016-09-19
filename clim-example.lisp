

(in-package :clim-user)


(define-application-frame test-frame () ()
  (:pane
   (vertically ()
     (make-clim-interactor-pane
      :foreground +green+
      :background +red+)
     (make-pane 'push-button
		:label (make-graphical-label))
     (make-pane 'push-button
		:label "press me"
		:activate-callback (command-callback #'(lambda (gadget) (print :hello)))
		:background +black+
		:foreground +cyan+
		:text-style (make-text-style :serif :roman 20)))))




(define-application-frame test ()
  ()
  (:panes
   (display :application))
  (:layouts
   (default display)))

(define-test-command (com-quit :menu t) ()
  (frame-exit *application-frame*))

(defvar *test-frame* nil)

(defun test ()
  (flet ((run ()
	   (let ((frame (make-application-frame 'test)))
	     (setq *test-frame* frame)
	     (run-frame-top-level frame))))
    (mp:process-run-function "test" #'run)))




(test)
