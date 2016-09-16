# Training
# Makefile syntax:

train: FORCE
	(eval '$(SET_LIBRARY_PATH)' ; \
	$(ECHO) " \
	(progn \
	  (load \"misc/train.lisp\") \
	  (train-clim :frame-tests $(FRAME_TESTS) :train-times $(TRAIN_TIMES) \
		:benchmarkp $(TRAIN_BM) :profilep $(TRAIN_PROFILEP) \
		:compile $(TRAIN_COMPILE) :psview $(PSVIEW) \
		:hpglview $(HPGLVIEW)))" \
	| $(LISP) -I $(CLIM) $(CLOPTS))
	echo $(SYSTEM) trained!!!!

# the following two rules are used by make-dist so that we don't have
# to build a slim image to run the test suite

load-train: FORCE
	(eval '$(SET_LIBRARY_PATH)' ; \
	$(ECHO) " \
	  (setq sys::*libtk-pathname* \"$(TKLIB)\") \
	  (setq sys::*libxt-pathname* \"$(XTLIB)\") \
	  (setq sys::*libx11-pathname* \"$(XLIB)\") \
	  (setq sys::*libwnn-pathname* \"$(WNNLIB)\") \
	  (load \"misc/dev-load-1.lisp\") \
	  (load-it '$(SYSTEM)) \
	  (load \"misc/train.lisp\") \
	  (train-clim :frame-tests $(FRAME_TESTS) :train-times $(TRAIN_TIMES) \
		:benchmarkp $(TRAIN_BM) :profilep $(TRAIN_PROFILEP) \
		:compile $(TRAIN_COMPILE) :psview $(PSVIEW) \
		:hpglview $(HPGLVIEW) :report-file \"$(REPORT_FILE)\") \
	  (clim-test::generate-pretty-test-report :file \"$(REPORT_FILE)\")" \
	| $(LISP) -I $(CLIM) $(CLOPTS))
