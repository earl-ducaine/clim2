/*
** See the file LICENSE for the full license governing this code.
*
*/

/************************************************************************/
/* Support code for Xlib interface                                      */
/************************************************************************/

#include <X11/Xlib.h>

int lisp_XDrawString(register Display *dpy,
		     Drawable d,
		     GC gc,
		     int x,
		     int y,
		     register char *string,
		     register int start,
		     register int end) {
  XDrawString(dpy, d, gc, x, y, &string[start], end - start);
}

int lisp_XDrawString16(register Display *dpy,
		   Drawable d,
		   GC gc,
		   int x,
		   int y,
		   register XChar2b *string,
		   register int start,
		   register int end) {
  XDrawString16(dpy, d, gc, x, y, &string[start], end - start);
}
