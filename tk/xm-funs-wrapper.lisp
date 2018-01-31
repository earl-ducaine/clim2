;; See the file LICENSE for the full license governing this code.

;; This file contains compile time only code -- put in clim-debug.fasl.

(in-package :tk)

(defparameter *capture-args-return-results* t)

(defparameter *sequential-calls* '())

;; No doc strings!
;; (defmacro instrumented-defun (name args &body body)
;;   (let ((local-name (gensym))
;; 	(local-args (gensym))
;; 	(local-body (gensym)))
;;     (eval `(let ((,local-name ',name)
;; 		 (,local-args ',args)
;; 		 (,local-body ',body))
;; 	     (defun ,local-name ,local-args
;; 	       (progn
;; 		 ;; (push (list ,local-name ,local-args ,@local-body) *sequential-calls*)
;; 		 ,@local-body))))))

(defparameter *calls-to-methods* '())

(defmacro instrumented-defun (method-name args &body body)
  (let ((local-results (gensym)))
  `(setf (fdefinition ',method-name)
	 (lambda ,args
	   (let ((,local-results (progn ,@body)))
	     (push (list :args ,@args :results ,local-results)
		   *calls-to-methods*)
	     ,local-results)))))

(instrumented-defun xm_string_create_localized (text)
		    (alisp_xm_string_create_localized text))

(instrumented-defun xm_string_create_l_to_r (x y)
		    (alisp_xm_string_create_l_to_r x y))

(instrumented-defun xm_string_concat (x y)
		    (alisp_xm_string_concat x y))

(instrumented-defun xm_string_copy (x)
		    (alisp_xm_string_copy x))

(instrumented-defun xm_string_unparse (string tag tag-type output-type parse-table
					      parse-count parse-model)
		    (xm_string_unparse string tag tag-type output-type parse-table parse-count parse-model))

(instrumented-defun  xm_string_get_l_to_r (x y z)
		     (alisp_xm_string_get_l_to_r x y z))

;;; New method to support Motif2.1

(instrumented-defun xm_string_free (x)
		    (alisp_xm_string_free x))

(instrumented-defun xm_get_pixmap (w x y z)
		    (alisp_xm_get_pixmap w x y z))

(instrumented-defun xm_font_list_init_font_context (x y)
		    (alisp_xm_font_list_init_font_context x y))

(instrumented-defun xm_font_list_free_font_context (x)
		    (alisp_xm_font_list_free_font_context x))

(instrumented-defun xm_font_list_get_next_font (x y z)
		    (alisp_xm_font_list_free_font_context x y z))

(instrumented-defun xm_font_list_create (x y)
		    (alisp_xm_font_list_create x y))

(instrumented-defun xm_font_list_free (x)
		    (alisp_xm_font_list_free x))

(instrumented-defun xm_font_list_entry_free (x)
		    (alisp_xm_font_list_entry_free x))

(instrumented-defun xm_im_mb_lookup_string (widget event buffer bytes-in-buffer fixnum)
		    (alisp_xm_im_mb_lookup_string widget event buffer bytes-in-buffer fixnum))

(instrumented-defun xm_add_protocol_callback (v w x y z)
		    (alisp_xm_add_protocol_callback v w x y z))

(instrumented-defun xm_intern_atom (x y z)
		    (alisp_xm_intern_atom x y z))

(instrumented-defun xm_main_window_set_area (a b c d e f)
		    (alisp_xm_main_window_set_area a b c d e f))

(instrumented-defun xm_process_traversal (x y)
		    (alisp_xm_process_traversal x y))

(instrumented-defun xm-message-box-get-child (x y)
		    (alisp_xm-message-box-get-child x y))

(instrumented-defun xm-selection-box-get-child (x y)
		    (alisp_xm-selection-box-get-child x y))

(instrumented-defun xm_file_selection_do_search (x y)
		    (alisp_xm_file_selection_do_search x y))

(instrumented-defun xm_option_label_gadget (x)
		    (alisp_xm_option_label_gadget x))

(instrumented-defun xm_option_button_gadget (x)
		    (alisp_xm_option_button_gadget x))

(instrumented-defun initializemydrawingareaquerygeometry (x)
		    (alisp_initializemydrawingareaquerygeometry x))

(instrumented-defun xm_get_focus_widget (x)
		    (alisp_xm_get_focus_widget x))

(instrumented-defun xm_is_traversable (x)
		    (alisp_xm_is_traversable x))

(instrumented-defun xm_font_list_append_entry (x y)
		    (alisp_xm_font_list_append_entry x y))

(instrumented-defun xm_font_list_entry_create (x y z)
		    (alisp_xm_font_list_entry_create x y z))

(instrumented-defun xm_font_list_entry_get_font (x y)
		    (alisp_xm_font_list_entry_get_font x y))

(instrumented-defun xm_font_list_next_entry (x)
		    (alisp_xm_font_list_next_entry x))

(instrumented-defun xm_toggle_button_set_state (x y z)
		    (alisp_xm_toggle_button_set_state x y z))

(instrumented-defun xm_toggle_button_get_state (x)
		    (alisp_xm_toggle_button_get_state x))

(instrumented-defun xm_text_field_get_selection (x)
		    (alisp_xm_text_field_get_selection x))

(instrumented-defun xm_text_get_selection (x)
		    (alisp_xm_text_get_selection x))

(instrumented-defun xm_text_set_selection (x first last time)
		    (alisp_xm_text_set_selection x first last time))

(instrumented-defun xm_scale_set_value (x y)
		    (alisp_xm_scale_set_value x y))

(instrumented-defun xm_get_display (x)
		    (alisp_xm_get_display x))

(instrumented-defun xm_change_color (x y)
		    (alisp_xm_change_color x y))
