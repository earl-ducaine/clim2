#  Makefile.defs for CLIM 2.0

# where to dump the CLIM images
CLIM		= clim.dxl

SHARED_EXT = so

LISP	= alisp
CL	= $(LISP) -I ~/dev/acl100express/alisp.dxl
CLOPTS	= -qq -batch -backtrace-on-error -locale japan.euc
RM	= rm
CAT	= cat
ECHO	= echo
TAGS	= etags
SHELL	= sh

# Lisp optimization for compiling
SPEED	?= 3
SAFETY	?= 1
# This next should be set to 1 for distribution
DEBUG   ?= 1

# Training
TRAIN_TIMES=1
# view, file, print
PSVIEW=:file
HPGLVIEW=:file
TRAIN_COMPILE=t
TRAIN_PROFILEP=t
TRAIN_BM=t
FRAME_TESTS=t

CFLAGS	= -O -D_NO_PROTO -DSTRINGS_ALIGNED -DNO_REGEX -DNO_ISDIR \
	 	-DUSE_RE_COMP -DUSER_GETWD

# Used for tags
ALL_SRC = *.lisp */*.lisp *.cl */*.cl *.c */*.c *.h */*.h

# These are the files that make up the source code product.
PRODUCT_SRC_FILES = sys/*.lisp utils/*.lisp  silica/*.lisp clim/*.lisp \
	demo/*.lisp test/test-suite.lisp

# This has to be kept consistent with xlib/xlib-funs.lisp
UNDEFS=misc/undefinedsymbols

# This has to be kept consistent with tk/xt-funs.lisp
XT_UNDEFS=misc/undefinedsymbols.xt

# This has to be kept consistent with tk/xm-funs.lisp
XM_UNDEFS=misc/undefinedsymbols.motif
# This has to be kept consistent with tk/xm-classes.lisp
XMC_UNDEFS=misc/undefinedsymbols.cmotif

# This has to be kept consistent with tk/ol-funs.lisp
OL_UNDEFS=misc/undefinedsymbols.olit
# This has to be kept consistent with tk/ol-classes.lisp
OLC_UNDEFS=misc/undefinedsymbols.colit

# This has to be kept consistent with wnn/jl-funs.lisp
WNN_UNDEFS=misc/undefinedsymbols.wnn

# These are the fasls and the .o that form the product

PRODUCT-GENERIC-FASLS = \
	climg.fasl climdemo.fasl clim-debug.fasl climps.fasl \
	climhpgl.fasl # climgg.fasl

PRODUCT-XM-FASLS = climxm.fasl clim-debugxm.fasl
PRODUCT-OL-FASLS = climol.fasl clim-debugol.fasl

PRODUCT-WNN-FASLS = climwnn.fasl clim-debugwnn.fasl

PRODUCT-GENERIC-OBJS= \
	stub-xt.o stub-x.o xtsupport.o xlibsupport.o

STATIC-XM-OBJS= stub-motif.o xmsupport.o
SHARED-XM-OBJS= climxm.$(SHARED_EXT)

STATIC-OL-OBJS= stub-olit.o olsupport.o
SHARED-OL-OBJS= climol.$(SHARED_EXT)

WNNLIB = libwnn.a
STATIC-WNN-OBJS=stub-wnn.o $(WNNLIB)

SYSTEM=		motif-clim

PRODUCT-FASLS=  $(PRODUCT-GENERIC-FASLS) $(PRODUCT-XM-FASLS)
PRODUCT-OBJS=	$(PRODUCT-GENERIC-OBJS) $(STATIC-XM-OBJS)

ICS-PRODUCT-FASLS= $(PRODUCT-WNN-FASLS)
ICS-PRODUCT-OBJS=  $(STATIC-WNN-OBJS)

# Makefile=Makefile

# ifeq ($(shell if test -d /usr/include/openmotif; then echo yes; fi),yes)
# XINCLUDES = -I/usr/include/openmotif
# XLIBDIR   = /usr/lib/openmotif
# endif

# This is the old location, but include it here, just in case
# ifeq ($(shell if test -d /usr/X11R6/include; then echo yes; fi),yes)
# XINCLUDES = -I/usr/X11R6/include
# XLIBDIR   = /usr/X11R6/lib
# endif

XINCLUDES ?= /usr/include
XLIBDIR   ?= /usr/lib

TKLIB=-lXm -lXpm -lXext -lXp
XTLIB=-lXt
XLIB=-lX11

ifdef FI_USE_DMALLOC
THREADLIB = -lpthread -ldmallocth
CFLAGS = -I/usr/local/include
else
THREADLIB = -lpthread
endif

SET_LIBRARY_PATH = LD_RUN_PATH=$(XLIBDIR):/lib:/usr/lib; export LD_RUN_PATH

PRODUCT-OBJS= $(PRODUCT-GENERIC-OBJS) $(STATIC-XM-OBJS) $(SHARED-XM-OBJS)

SHAREFLAGS =
MAKE_SHARED = ld -shared -L$(XLIBDIR)
STD_DEFINES = -DSVR4 -DSYSV
AR = ar cq

#  Makefile.generic for CLIM 2.0

all: compile cat # $(CLIM)
makeclimfasls: compile cat


compile_depends = wnn.$(SHARED_EXT)


compile: FORCE $(PRODUCT-OBJS) $(ICS-PRODUCT-OBJS) $(compile_depends)
	(eval '$(SET_LIBRARY_PATH)'; \
	 bash runlisp.sh -f build.tmp $(build_runlisp_args) \
	 $(CL) $(CLOPTS))

# Concatenation
cat: compile
	(eval '$(SET_LIBRARY_PATH)'; \
	 bash runlisp.sh -f cat.tmp $(concat_runlisp_args) $(CL) $(CLOPTS))

$(PRODUCT-FASLS) $(ICS-PRODUCT_FASLS): cat


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
	@ls -lLt $(CLIM) >> Clim-sizes.n
	@ls -lLt $(CLIM)
	@echo $(SYSTEM) built!!!!

# Training

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

generate_test_report: FORCE
	($(ECHO) " \
	(clim-test::generate-pretty-test-report :file \"$(REPORT_FILE)\")" \
	| $(LISP) -I $(CLIM) $(CLOPTS))

profile: FORCE
	($(ECHO) " \
	(clim-user::run-profile-clim-tests)" \
	| $(LISP) -I $(CLIM) $(CLOPTS))

benchmark: FORCE
	($(ECHO) " \
	(clim-test::benchmark-clim nil)" \
	| $(LISP) -I $(CLIM) $(CLOPTS))

testps: FORCE
	($(ECHO) " \
	(load \"test/postscript-tests.lisp\") \
	(clim-user::run-postscript-tests :output $(PSVIEW))" \
	| $(LISP) -I $(CLIM) $(CLOPTS))

# Misc

cleanobjs:
	rm -f *.o

cleanfasls: FORCE
	find . -name '*.fasl' -print | xargs rm -f

clean:

	# rm -f *.out *.tmp
	rm -rf ~/.cache/common-lisp
	rm -f *.out
	find . -name '*.fasl' -print | xargs rm -f

	rm Clim-sizes.n
	rm -f *.o *.$(SHARED_EXT) *.a slim \
	  	stub-motif.c stub-olit.c stub-xt.c stub-x.c stub-wnn.c
	rm -f *.z *.Z *.gz *.ilt so_locations
	rm -f *.pll *.dxl

clean-notes:
	cd notes; find . -name '*.lisp' -print | xargs rm -f

tags:	FORCE
	rm -f TAGS
	find . -name '*.lisp' -print | xargs $(TAGS) -a

wc:
	wc $(ALL_SRC)

echo_XTLIB:
	@echo $(XTLIB)

echo_XLIB:
	@echo $(XLIB)

echo_TKLIB:
	@echo $(TKLIB)

echo_WNNLIB:
	@echo $(WNNLIB)

makeclimobjs: $(PRODUCT-OBJS) $(ICS-PRODUCT-OBJS)

install_obj:
	cp $(PRODUCT-OBJS) $(ICS-PRODUCT-OBJS) $(DEST)

install_clim: install_obj
	cp $(PRODUCT-FASLS) $(ICS-PRODUCT-FASLS) $(DEST)

echo_src_files:
	@echo $(PRODUCT_SRC_FILES)

#
#  Makefile.cobj for CLIM 2.0
#

# stub files - identify the required definitions from Xm,Ol,Xt,X11

stub-motif.c: $(XMC_UNDEFS) $(XM_UNDEFS) misc/make-stub-file misc/make-stub-file1
	sh misc/make-stub-file "void ___lisp_load_motif_stub ()"  \
		$(XM_UNDEFS) > stub-motif.c
	sh misc/make-stub-file1 "void ___lisp_load_motif_stub_vars ()" \
		$(XMC_UNDEFS) >> stub-motif.c

stub-olit.c: $(OLC_UNDEFS) $(OL_UNDEFS) misc/make-stub-file misc/make-stub-file1
	sh misc/make-stub-file "void ___lisp_load_olit_stub ()"  \
		$(OL_UNDEFS) > stub-olit.c
	sh misc/make-stub-file1 "void ___lisp_load_olit_stub_vars ()" \
		$(OLC_UNDEFS) >> stub-olit.c

stub-xt.c: $(XT_UNDEFS) misc/make-stub-file
	sh misc/make-stub-file "void ___lisp_load_xt_stub ()" \
		$(XT_UNDEFS) > stub-xt.c

stub-x.c: $(UNDEFS) misc/make-stub-file
	sh misc/make-stub-file "void ___lisp_load_x_stub ()"  \
		$(UNDEFS) > stub-x.c

stub-wnn.c: $(WNN_UNDEFS) misc/make-stub-file
	sh misc/make-stub-file "void ___lisp_load_wnn_stub ()" \
		$(WNN_UNDEFS) > stub-wnn.c

# support files - CLIM's C source files

xmsupport.o : misc/xmsupport.c misc/climgccursor.c \
		misc/MyDrawingA.c misc/MyDrawingA.h misc/MyDrawingAP.h
	$(CC) -c $(PICFLAGS) $(CFLAGS) $(XINCLUDES) \
		-o xmsupport.o misc/xmsupport.c

olsupport.o: misc/olsupport.c misc/climgccursor.c
	$(CC) -c $(PICFLAGS) $(CFLAGS) $(XINCLUDES) \
		-o olsupport.o misc/olsupport.c

xtsupport.o : misc/xtsupport.c
	$(CC) -c $(PICFLAGS) $(CFLAGS) $(XINCLUDES) \
		-o xtsupport.o misc/xtsupport.c

xlibsupport.o : xlib/xlibsupport.c
	$(CC) -c $(PICFLAGS) $(CFLAGS) $(XINCLUDES) \
		 -o xlibsupport.o xlib/xlibsupport.c

# .so's made from above support files (for dynamic loading)

climxm.$(SHARED_EXT): xlibsupport.o xtsupport.o xmsupport.o $(IMPORTS)
	(eval '$(SET_LIBRARY_PATH)' ; \
	$(MAKE_SHARED) $(SHAREFLAGS) -o climxm.$(SHARED_EXT) \
		xlibsupport.o xtsupport.o xmsupport.o $(THREADLIB) \
		$(IMPORTS) $(TKLIB) $(XTLIB) $(XLIB) $(MOTIFXTRAS))

climol.$(SHARED_EXT): xlibsupport.o xtsupport.o olsupport.o $(IMPORTS)
	(eval '$(SET_LIBRARY_PATH)' ; \
	$(MAKE_SHARED) $(SHAREFLAGS) -o climol.$(SHARED_EXT) \
		xlibsupport.o xtsupport.o olsupport.o \
		$(IMPORTS) $(TKLIB) $(XTLIB) $(XLIB))

# climol.sl: xlibsupport.o xtsupport.o olsupport.o $(IMPORTS)
# 	(eval '$(SET_LIBRARY_PATH)' ; \
# 	$(MAKE_SHARED) $(SHAREFLAGS) -o climol.sl \
# 		xlibsupport.o xtsupport.o olsupport.o \
#		$(IMPORTS) $(TKLIB) $(XTLIB) $(XLIB))

# mainxm.o contains foreign code from the libraries X11,Xt and Xm
# required by Motif version of CLIM statically linked

makemainxm: $(ACL_MAIN_OBJ) $(PRODUCT-GENERIC-OBJS) $(STATIC-XM-OBJS)
	(eval '$(SET_LIBRARY_PATH)' ; \
	ld -r $(LDFLAGS) -o $(MAIN_OBJ) \
		$(ACL_MAIN_OBJ) \
		stub-xt.o stub-x.o stub-motif.o \
		$(TKLIB) $(XTLIB) $(XLIB) $(MOTIFXTRAS))

WNNFLAGS = -DJAPANESE -DCHINESE -DKOREAN -DLATIN -DWRITE_CHECK -DWNNDEFAULT \
	$(PICFLAGS)

WNN_OBJS= js.o wnnerrmsg.o jl.o \
	msg.o yincoding.o py_table.o zy_table.o strings.o bcopy.o \
	rk_bltinfn.o rk_main.o rk_modread.o rk_read.o rk_vars.o

js.o: wnn/js.c wnn/bdic.c wnn/pwd.c
	$(CC) -c $(WNNFLAGS) $(STD_DEFINES) $(CFLAGS) \
		-o js.o wnn/js.c

wnnerrmsg.o : wnn/wnnerrmsg.c
	$(CC) -c $(WNNFLAGS) $(STD_DEFINES) $(CFLAGS) \
		-o wnnerrmsg.o wnn/wnnerrmsg.c

jl.o : wnn/jl.c
	$(CC) -c $(WNNFLAGS) $(STD_DEFINES) $(CFLAGS) \
		-o jl.o wnn/jl.c

msg.o : wnn/msg.c
	$(CC) -c $(WNNFLAGS) $(STD_DEFINES) $(CFLAGS) \
		-o msg.o wnn/msg.c

yincoding.o : wnn/yincoding.c
	$(CC) -c $(WNNFLAGS) $(STD_DEFINES) $(CFLAGS) \
		-o yincoding.o wnn/yincoding.c

py_table.o : wnn/py_table.c
	$(CC) -c $(WNNFLAGS) $(STD_DEFINES) $(CFLAGS) \
		-o py_table.o wnn/py_table.c

zy_table.o : wnn/zy_table.c
	$(CC) -c $(WNNFLAGS) $(STD_DEFINES) $(CFLAGS) \
		-o zy_table.o wnn/zy_table.c

strings.o : wnn/strings.c
	$(CC) -c $(WNNFLAGS) $(STD_DEFINES) $(CFLAGS) \
		-o strings.o wnn/strings.c

bcopy.o : wnn/bcopy.c
	$(CC) -c $(WNNFLAGS) $(STD_DEFINES) $(CFLAGS) \
		-o bcopy.o wnn/bcopy.c

rk_bltinfn.o : wnn/rk_bltinfn.c
	$(CC) -c $(WNNFLAGS) $(STD_DEFINES) $(CFLAGS) \
		-o rk_bltinfn.o wnn/rk_bltinfn.c

rk_main.o : wnn/rk_main.c
	$(CC) -c $(WNNFLAGS) $(STD_DEFINES) $(CFLAGS) \
		-o rk_main.o wnn/rk_main.c

rk_modread.o : wnn/rk_modread.c
	$(CC) -c $(WNNFLAGS) $(STD_DEFINES) $(CFLAGS) \
		-o rk_modread.o wnn/rk_modread.c

rk_read.o : wnn/rk_read.c
	$(CC) -c $(WNNFLAGS) $(STD_DEFINES) $(CFLAGS) \
		-o rk_read.o wnn/rk_read.c

rk_vars.o : wnn/rk_vars.c
	$(CC) -c $(WNNFLAGS) $(STD_DEFINES) $(CFLAGS) \
		-o rk_vars.o wnn/rk_vars.c

libwnn.a: $(WNN_OBJS)
	$(AR) $@ $(WNN_OBJS)

wnn.$(SHARED_EXT): $(WNN_OBJS)
	$(MAKE_SHARED) $(SHAREFLAGS) -o wnn.$(SHARED_EXT) $(WNN_OBJS) \
		$(REDHATLIBS) $(THREADLIB)

FORCE:
