#  Makefile.defs for CLIM 2.0

# where to dump the CLIM images
CL	= alisp -I alisp.dxl -qq -batch -backtrace-on-error -locale japan.euc


SET_LIBRARY_PATH = LD_RUN_PATH=/usr/lib:/lib:/usr/lib; export LD_RUN_PATH

all: compile cat
makeclimfasls: compile cat

compile: FORCE
	(eval '$(SET_LIBRARY_PATH)'; bash runlisp.sh build.tmp)

# Concatenation
cat: compile
	(eval '$(SET_LIBRARY_PATH)'; bash runlisp.sh cat.tmp)

clean:
	rm -rf ~/.cache/common-lisp
	find . -name '*.fasl' -print | xargs rm -f
	rm -f *.dxl

FORCE:
