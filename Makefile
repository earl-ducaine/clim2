# $fiHeader: Makefile,v 1.4 92/01/02 15:33:41 cer Exp Locker: cer $

SOMEDIRS=utils silica clim ws 
DIRS=$(SOMEDIRS) xlib tk xm-silica
DEVICE=/dev/null
CL=/usr/composer2/composer2

default: compile

compile : FRC
	$(CL) < misc/go.cl

clean : FRC
	find $(DIRS)  -name "*.fasl" -exec $(RM) "{}" \;

FRC :


swm-tape:
	tar cf $(DEVICE) `find misc $(SOMEDIRS) '(' -name "*.cl" -o -name "*.lisp" ')' -print`

xm-composer:
	cd tk ; $(MAKE) xm-composer

xm-dcl:
	cd tk ; $(MAKE) xm-dcl

# For the day the make dist happens.

echo_src_files:
	@find . '(' -name '*.cl' -o -name '*.lisp' ')' -print

