#  Makefile.defs for CLIM 2.0

# where to dump the CLIM images
CLIM		= clim.dxl

SHARED_EXT = so
LISP	= alisp

# Lisp optimization for compiling
SPEED	?= 3
SAFETY	?= 1
# This next should be set to 1 for distribution
DEBUG   ?= 1

# Training
TRAIN_TIMES=1
# view, file, print
PSVIEW=:file
FRAME_TESTS=t

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

# This has to be kept consistent with wnn/jl-funs.lisp
WNN_UNDEFS=misc/undefinedsymbols.wnn

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

PRODUCT-OBJS=	$(PRODUCT-GENERIC-OBJS) $(STATIC-XM-OBJS)

ICS-PRODUCT-OBJS=  $(STATIC-WNN-OBJS)

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

all: compile

compile_depends = wnn.$(SHARED_EXT)


compile: FORCE $(PRODUCT-OBJS) $(ICS-PRODUCT-OBJS) $(compile_depends)
	ls .

# Misc
clean:
	rm -rf ~/.cache/common-lisp
	find . -name '*.fasl' -print | xargs rm -f
	rm -f *.o *.$(SHARED_EXT) *.a \
	  	stub-motif.c stub-olit.c stub-xt.c stub-x.c stub-wnn.c
	rm -f *.dxl

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
