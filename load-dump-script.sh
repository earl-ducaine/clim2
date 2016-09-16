# Makefile syntax:

# Building (loading and dumping)

# It is VERY important not to side-effect
# logical-pathname-translations-database-pathnames in the building phase of
# clim*.dxl.  The reason: this change is propagated to delivered images,
# which is very bad.  Mostly, it's bad for testing because usually the
# value of (current-directory) below is accessible during testing and it is
# the wrong thing (we always want sys:hosts.cl to be used when testing a
# distribution that users will get).
$(CLIM): FORCE $(PRODUCT-OBJS) $(ICS-PRODUCT-OBJS)
	-$(RM) -f $(CLIM)
	(eval '$(SET_LIBRARY_PATH)' ; \
	$(ECHO) " \
	(progn \
	 (generate-application \
	   \"$(CLIM)\" \"./\" \
	   nil \
	   :pre-load-form \
	   (quote \
	     (progn \
	       (setq sys::*libtk-pathname* \"$(TKLIB)\") \
	       (setq sys::*libxt-pathname* \"$(XTLIB)\") \
	       (setq sys::*libx11-pathname* \"$(XLIB)\") \
	       (setq sys::*libwnn-pathname* \"$(WNNLIB)\") \
	       (excl:set-case-mode  :case-insensitive-upper) \
	       (load \"misc/dev-load-1.lisp\") \
	       (load-it '$(SYSTEM)))) \
	   :autoload-warning nil \
	   :image-only t \
	   :purify t \
	   :debug-on-error t \
	   :internal-debug \"build-clim.out\" \
	   :shlib-warning nil \
	   :libfasl-warning nil \
	   :record-source-file-info $(RECORD_SOURCE_FILE_INFO) \
	   :load-source-file-info $(LOAD_SOURCE_FILE_INFO) \
	   :record-xref-info $(RECORD_XREF_INFO) \
	   :load-xref-info $(LOAD_XREF_INFO) \
	   :discard-local-name-info t \
	   :discard-source-file-info t \
	   :discard-xref-info t) \
	 (exit 0))" | $(CL) $(CLOPTS))
	@echo $(SYSTEM) built!!!!
