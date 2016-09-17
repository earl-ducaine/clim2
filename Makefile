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


compile: FORCE
	(eval '$(SET_LIBRARY_PATH)'; bash runlisp.sh -f build.tmp $(build_runlisp_args) $(CL) $(CLOPTS))

# Concatenation
cat: compile
	(eval '$(SET_LIBRARY_PATH)'; \
	 bash runlisp.sh -f cat.tmp $(concat_runlisp_args) $(CL) $(CLOPTS))

$(PRODUCT-FASLS) $(ICS-PRODUCT_FASLS): cat

# Misc
clean:
	rm -rf ~/.cache/common-lisp
	find . -name '*.fasl' -print | xargs rm -f
	rm -f *.dxl



FORCE:
