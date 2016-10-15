CFLAGS	= -O -D_NO_PROTO -DSTRINGS_ALIGNED -DNO_REGEX -DNO_ISDIR \
	 	-DUSE_RE_COMP -DUSER_GETWD

# This has to be kept consistent with tk/xm-funs.lisp
XM_UNDEFS=misc/undefinedsymbols.motif
# This has to be kept consistent with tk/xm-classes.lisp
XMC_UNDEFS=misc/undefinedsymbols.cmotif

PRODUCT-GENERIC-OBJS= xtsupport.o xlibsupport.o
STATIC-XM-OBJS= stub-motif.o xmsupport.o
SHARED-XM-OBJS= climxm.so
SYSTEM=		motif-clim
XINCLUDES ?= /usr/include
XLIBDIR   ?= /usr/lib
TKLIB=-lXm -lXpm -lXext
XTLIB=-lXt
XLIB=-lX11
THREADLIB = -lpthread

SET_LIBRARY_PATH = LD_RUN_PATH=$(XLIBDIR):/lib:/usr/lib; export LD_RUN_PATH
PRODUCT-OBJS= $(PRODUCT-GENERIC-OBJS) $(STATIC-XM-OBJS) $(SHARED-XM-OBJS)

SHAREFLAGS =
MAKE_SHARED = ld -shared -L$(XLIBDIR)

all: compile

compile: FORCE $(PRODUCT-OBJS)  $(compile_depends)
	ls .

clean:
	find . -name '*.fasl' -print | xargs rm -f
	rm -f *.o *.so *.a
	rm -f *.dxl

xmsupport.o : misc/xmsupport.c misc/climgccursor.c misc/MyDrawingA.c misc/MyDrawingA.h misc/MyDrawingAP.h
	gcc -c $(PICFLAGS) $(CFLAGS) -o xmsupport.o misc/xmsupport.c

xtsupport.o : misc/xtsupport.c
	gcc -c $(PICFLAGS) $(CFLAGS) -o xtsupport.o misc/xtsupport.c

xlibsupport.o : xlib/xlibsupport.c
	gcc -c $(PICFLAGS) $(CFLAGS) $(XINCLUDES) -o xlibsupport.o xlib/xlibsupport.c

climxm.so: xlibsupport.o xtsupport.o xmsupport.o
	(eval '$(SET_LIBRARY_PATH)' ; \
	$(MAKE_SHARED) $(SHAREFLAGS) -o climxm.so \
		xlibsupport.o xtsupport.o xmsupport.o $(THREADLIB) \
		$(TKLIB) $(XTLIB) $(XLIB) $(MOTIFXTRAS))

FORCE:
