;; See the file LICENSE for the full license governing this code.
;;
;; This file contains compile time only code -- put in clim-debug.fasl.


(in-package :xt)

(defparameter *capture-args-return-results* t)

(defparameter *sequential-calls* '())

(defparameter *calls-to-methods* '())

(defmacro instrumented-defun (method-name args &body body)
  (let ((local-results (gensym)))
  `(setf (fdefinition ',method-name)
	 (lambda ,args
	   (let ((,local-results (progn ,@body)))
	     (push (list :args ,@args :results ,local-results)
		   *calls-to-methods*)
	     ,local-results)))))

(instrumented-defun xt_get_resource_list (x y z)
  (alisp_xt_get_resource_list x y z))

(instrumented-defun xt_get_constraint_resource_list (x y z)
  (alisp_xt_get_constraint_resource_list x y z))

(instrumented-defun xt_initialize_widget_class (x)
  (alisp_xt_initialize_widget_class x))

(instrumented-defun xt_free (x)
  (alisp_xt_free x))

(instrumented-defun xt_toolkit_initialize ()
  (alisp_xt_toolkit_initialize ))

(instrumented-defun xt_create_application_context ()
  (alisp_xt_create_application_context ))

(instrumented-defun xt_destroy_application_context (x)
  (alisp_xt_destroy_application_context x))

(instrumented-defun xt_app_set_error_handler (x y)
  (alisp_xt_app_set_error_handler x y))

(instrumented-defun xt_app_set_warning_handler (x y)
  (alisp_xt_app_set_warning_handler x y))

(instrumented-defun xt_open_display (a b c d e f g h)
  (alisp_xt_open_display a b c d e f g h))

(instrumented-defun xt_close_display (x)
  (alisp_xt_close_display x))

(instrumented-defun xt_database (x)
  (alisp_xt_database x))

(instrumented-defun xt_get_application_name_and_class (x y z)
  (alisp_xt_get_application_name_and_class x y z))

(instrumented-defun xt_convert_and_store (a b c d e)
  (alisp_xt_convert_and_store a b c d e))

(instrumented-defun xt_app_create_shell (a b c d e f)
  (alisp_xt_app_create_shell a b c d e f))

(instrumented-defun xt_create_widget (a b c d e)
  (alisp_xt_create_widget a b c d e))

(instrumented-defun xt_create_managed_widget (a b c d e)
  (alisp_xt_create_managed_widget a b c d e))

(instrumented-defun xt_realize_widget (x)
  (alisp_xt_realize_widget x))

(instrumented-defun xt_is_realized (x)
  (alisp_xt_is_realized x))

(instrumented-defun xt_destroy_widget (x)
  (alisp_xt_destroy_widget x))

(instrumented-defun xt_manage_child (x)
  (alisp_xt_manage_child x))

(instrumented-defun xt_is_managed (x)
  (alisp_xt_is_managed x))

(instrumented-defun xt_unmanage_child (x)
  (alisp_xt_unmanage_child x))

(instrumented-defun xt_unmap_widget (x)
  (alisp_xt_unmap_widget x))

(instrumented-defun xt_manage_children (x y)
  (alisp_xt_manage_children x y))

(instrumented-defun xt_unmanage_children (x y)
  (alisp_xt_unmanage_children x y))

(instrumented-defun xt_create_popup_shell (a b c d e)
  (alisp_xt_create_popup_shell a b c d e))

(instrumented-defun xt_popup (x y)
  (alisp_xt_popup x y))

(instrumented-defun xt_popdown (x)
  (alisp_xt_popdown x))

(instrumented-defun xt_window (x)
  (alisp_xt_window x))

(instrumented-defun xt_parent (x)
  (alisp_xt_parent x))

(instrumented-defun xt_name (x)
  (alisp_xt_name x))

(instrumented-defun xt_class (x)
  (alisp_xt_class x))

(instrumented-defun xt_query_geometry (x y z)
  (alisp_xt_query_geometry x y z))

(instrumented-defun xt_configure_widget (a b c d e f)
  (alisp_xt_configure_widget a b c d e f))

(instrumented-defun xt_set_values (x y z)
  (alisp_xt_set_values x y z))

(instrumented-defun xt_get_values (x y z)
  (alisp_xt_get_values x y z))

(instrumented-defun xt_app_pending (x)
  (alisp_xt_app_pending x))

(instrumented-defun xt_app_peek_event (x y)
  (alisp_xt_app_peek_event x y))

(instrumented-defun xt_app_process_event (x y)
  (alisp_xt_app_process_event x y))

(instrumented-defun xt_app_interval_next_timer (x)
  (alisp_xt_app_interval_next_timer x))

(instrumented-defun xt_add_event_handler (a b c d e)
  (alisp_xt_add_event_handler a b c d e))

(instrumented-defun xt_build_event_mask (x)
  (alisp_xt_build_event_mask x))

(instrumented-defun xt_add_callback (w x y z)
  (alisp_xt_add_callback w x y z))

(instrumented-defun xt_has_callbacks (x y)
  (alisp_xt_has_callbacks x y))

(instrumented-defun xt_remove_all_callbacks (x y)
  (alisp_xt_remove_all_callbacks x y))

(instrumented-defun xt_set_sensitive (x y)
  (alisp_xt_set_sensitive x y))

(instrumented-defun xt_grab_pointer (display widget owner pgrabmode kgrabmode confine-to cursor time)
  (alisp_xt_grab_pointer display widget owner pgrabmode kgrabmode confine-to cursor time))

(instrumented-defun xt_ungrab_pointer (display time)
  (alisp_xt_ungrab_pointer display time))

(instrumented-defun xt_ungrab_button (widget button modifiers)
  (alisp_xt_ungrab_button widget button modifiers))

(instrumented-defun xt-last-timestamp-processed (display)
  (alisp_xt-last-timestamp-processed display))

(instrumented-defun xt_set_keyboard_focus (x y)
  (alisp_xt_set_keyboard_focus x y))

(instrumented-defun init_clim_gc_cursor_stuff (x)
  (alisp_init_clim_gc_cursor_stuff x))

(instrumented-defun set_clim_gc_cursor_widget (x y)
  (alisp_set_clim_gc_cursor_widget x y))

(instrumented-defun xt_parse_translation_table (x)
  (alisp_xt_parse_translation_table x))

(instrumented-defun xt_parse_accelerator_table (x)
  (alisp_xt_parse_accelerator_table x))

(instrumented-defun xt_app_set_fallback_resources (x y)
  (alisp_xt_app_set_fallback_resources x y))

(instrumented-defun xt_widget_num_popups (x)
  (alisp_xt_widget_num_popups x))

(instrumented-defun xt_set_language_proc (x y z)
  (alisp_xt_set_language_proc x y z))

;; This isn't part of Xt but is useful for debugging. The locale
;; handling is all done through XtSetLanguageProc above

(instrumented-defun setlocale-1 (x y)
  (alisp_setlocale-1 x y))

(instrumented-defun x-supports-locale ()
  (alisp_x-supports-locale ))

(instrumented-defun x-set-locale-modifiers (x)
  (alisp_x-set-locale-modifiers x))
