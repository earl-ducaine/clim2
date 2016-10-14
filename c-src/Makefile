
CFLAGS	= -O -D_NO_PROTO -DSTRINGS_ALIGNED -DNO_REGEX -DNO_ISDIR \
	 	-DUSE_RE_COMP -DUSER_GETWD

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

PRODUCT-XM-FASLS = climxm.fasl clim-debugxm.fasl
PRODUCT-OL-FASLS = climol.fasl clim-debugol.fasl

PRODUCT-WNN-FASLS = climwnn.fasl clim-debugwnn.fasl

PRODUCT-GENERIC-OBJS= \
	stub-xt.o stub-x.o xtsupport.o xlibsupport.o

STATIC-XM-OBJS= stub-motif.o xmsupport.o
SHARED-XM-OBJS= climxm.so
SYSTEM=		motif-clim
PRODUCT-OBJS=	$(PRODUCT-GENERIC-OBJS) $(STATIC-XM-OBJS)
XINCLUDES ?= /usr/include
XLIBDIR   ?= /usr/lib

TKLIB=-lXm -lXpm -lXext
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

all: compile

compile: FORCE $(PRODUCT-OBJS)  $(compile_depends)
	ls .

clean:
	find . -name '*.fasl' -print | xargs rm -f
	rm -f *.o *.so *.a \
	  	stub-motif.c  stub-xt.c stub-x.c
	rm -f *.dxl

stub-motif.c: $(XMC_UNDEFS) $(XM_UNDEFS) misc/make-stub-file misc/make-stub-file1
	sh misc/make-stub-file "void ___lisp_load_motif_stub ()"  \
		$(XM_UNDEFS) > stub-motif.c
	sh misc/make-stub-file1 "void ___lisp_load_motif_stub_vars ()" \
		$(XMC_UNDEFS) >> stub-motif.c

stub-xt.c: $(XT_UNDEFS) misc/make-stub-file
	sh misc/make-stub-file "void ___lisp_load_xt_stub ()" \
		$(XT_UNDEFS) > stub-xt.c

stub-x.c: $(UNDEFS) misc/make-stub-file
	sh misc/make-stub-file "void ___lisp_load_x_stub ()"  \
		$(UNDEFS) > stub-x.c

xmsupport.o : misc/xmsupport.c misc/climgccursor.c \
		misc/MyDrawingA.c misc/MyDrawingA.h misc/MyDrawingAP.h
	$(CC) -c $(PICFLAGS) $(CFLAGS) $(XINCLUDES) \
		-o xmsupport.o misc/xmsupport.c

xtsupport.o : misc/xtsupport.c
	$(CC) -c $(PICFLAGS) $(CFLAGS) $(XINCLUDES) \
		-o xtsupport.o misc/xtsupport.c

xlibsupport.o : xlib/xlibsupport.c
	$(CC) -c $(PICFLAGS) $(CFLAGS) $(XINCLUDES) \
		 -o xlibsupport.o xlib/xlibsupport.c

climxm.so: xlibsupport.o xtsupport.o xmsupport.o $(IMPORTS)
	(eval '$(SET_LIBRARY_PATH)' ; \
	$(MAKE_SHARED) $(SHAREFLAGS) -o climxm.so \
		xlibsupport.o xtsupport.o xmsupport.o $(THREADLIB) \
		$(IMPORTS) $(TKLIB) $(XTLIB) $(XLIB) $(MOTIFXTRAS))

FORCE:
