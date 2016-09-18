#  Makefile.defs for CLIM 2.0

# where to dump the CLIM images
CLIM		= clim.dxl

LISP	= alisp
CL	= $(LISP) -I ~/dev/acl100express/alisp.dxl
CLOPTS	= -qq -batch -backtrace-on-error -locale japan.euc

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

PRODUCT-WNN-FASLS = climwnn.fasl clim-debugwnn.fasl

PRODUCT-GENERIC-OBJS= \
	stub-xt.o stub-x.o xtsupport.o xlibsupport.o

STATIC-XM-OBJS= stub-motif.o xmsupport.o
SHARED-XM-OBJS= climxm.so

STATIC-OL-OBJS= stub-olit.o olsupport.o
SHARED-OL-OBJS= climol.so

WNNLIB = libwnn.a
STATIC-WNN-OBJS=stub-wnn.o $(WNNLIB)


XLIBDIR   ?= /usr/lib

SET_LIBRARY_PATH = LD_RUN_PATH=$(XLIBDIR):/lib:/usr/lib; export LD_RUN_PATH

all: compile cat
makeclimfasls: compile cat

compile_depends = wnn.so

compile: FORCE
	(eval '$(SET_LIBRARY_PATH)'; bash runlisp.sh -f build.tmp $(build_runlisp_args) $(CL) $(CLOPTS))

# Concatenation
cat: compile
	(eval '$(SET_LIBRARY_PATH)'; \
	 bash runlisp.sh -f cat.tmp $(concat_runlisp_args) $(CL) $(CLOPTS))

clean:
	rm -rf ~/.cache/common-lisp
	find . -name '*.fasl' -print | xargs rm -f
	rm -f *.dxl

FORCE:
