;; See the file LICENSE for the full license governing this code.
;;

;;; (c) Copyright  1990 Sun Microsystems, Inc.  All Rights Reserved.
;;      (c) Copyright 1989, 1990, 1991 Sun Microsystems, Inc. Sun design
;;      patents pending in the U.S. and foreign countries. OPEN LOOK is a
;;      registered trademark of USL. Used by written permission of the owners.
;;
;;      (c) Copyright Bigelow & Holmes 1986, 1985. Lucida is a registered
;;      trademark of Bigelow & Holmes. Permission to use the Lucida
;;      trademark is hereby granted only in association with the images
;;      and fonts described in this file.
;;
;;      SUN MICROSYSTEMS, INC., USL, AND BIGELOW & HOLMES
;;      MAKE NO REPRESENTATIONS ABOUT THE SUITABILITY OF
;;      THIS SOURCE OR OBJECT CODE FOR ANY PURPOSE. IT IS PROVIDED "AS IS"
;;      WITHOUT EXPRESS OR IMPLIED WARRANTY OF ANY KIND.
;;      SUN  MICROSYSTEMS, INC., USL AND BIGELOW  & HOLMES,
;;      SEVERALLY AND INDIVIDUALLY, DISCLAIM ALL WARRANTIES
;;      WITH REGARD TO THIS CODE, INCLUDING ALL IMPLIED
;;      WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A
;;      PARTICULAR PURPOSE. IN NO EVENT SHALL SUN MICROSYSTEMS,
;;      INC., USL OR BIGELOW & HOLMES BE LIABLE FOR ANY
;;      SPECIAL, INDIRECT, INCIDENTAL, OR CONSEQUENTIAL DAMAGES,
;;      OR ANY DAMAGES WHATSOEVER RESULTING FROM LOSS OF USE, DATA
;;      OR PROFITS, WHETHER IN AN ACTION OF  CONTRACT, NEGLIGENCE
;;      OR OTHER TORTIOUS ACTION, ARISING OUT OF OR IN CONNECTION
;;      WITH THE USE OR PERFORMANCE OF THIS OBJECT CODE.

(in-package :x11)


;; (cffi:defctype pointer-struct-display (:pointer (:struct display)))

;; (defmethod cffi::translate-to-foreign (object (type pointer-struct-display-type))
;;   (ff-wrapper::foreign-pointer-address object))

;; (cffi:define-foreign-type pointer-struct-display-type ()
;;   ()
;;   (:actual-type :pointer)
;;   (:simple-parser pointer-struct-display))

(eval-when (:compile-toplevel :load-toplevel :execute)
  (run-create-translation-for-base-type))
  


(def-exported-foreign-function (xalloccolorcells (:return-type int) (:name "XAllocColorCells"))
    (dpy pointer-struct-display)
  (cmap colormap)
  (contig int)
  (masks (:pointer unsigned-long))
  (nplanes unsigned-int)
  (pixels (:pointer unsigned-long))
  (ncolors unsigned-int))

(def-exported-foreign-function (xalloccolorplanes (:return-type int) (:name "XAllocColorPlanes"))
    (dpy pointer-struct-display)
  (cmap colormap)
  (contig int)
  (pixels (:pointer unsigned-long))
  (ncolors int)
  (nreds int)
  (ngreens int)
  (nblues int)
  (rmask (:pointer unsigned-long))
  (gmask (:pointer unsigned-long))
  (bmask (:pointer unsigned-long)))

(def-exported-foreign-function (xallowevents (:name "XAllowEvents"))
    (dpy pointer-struct-display)
  (mode int)
  (time :unsigned-32bit))

(def-exported-foreign-function (xautorepeaton (:name "XAutoRepeatOn"))
    (dpy pointer-struct-display))

(def-exported-foreign-function (xautorepeatoff (:name "XAutoRepeatOff"))
    (dpy pointer-struct-display))

(def-exported-foreign-function (xsetwindowbackground (:name "XSetWindowBackground"))
    (dpy pointer-struct-display)
  (w window)
  (pixel unsigned-long))

(def-exported-foreign-function (xsetwindowborderwidth (:name "XSetWindowBorderWidth"))
    (dpy pointer-struct-display)
  (w window)
  (width unsigned-int))

(def-exported-foreign-function (xbell (:name "XBell"))
    (dpy pointer-struct-display)
  (percent int))

(def-exported-foreign-function (xsetwindowborder (:name "XSetWindowBorder"))
    (dpy pointer-struct-display)
  (w window)
  (pixel unsigned-long))

(def-exported-foreign-function (xenableaccesscontrol (:name "XEnableAccessControl"))
    (dpy pointer-struct-display))

(def-exported-foreign-function (xdisableaccesscontrol (:name "XDisableAccessControl"))
    (dpy pointer-struct-display))

(def-exported-foreign-function (xsetaccesscontrol (:name "XSetAccessControl"))
    (dpy pointer-struct-display)
  (mode int))

(def-exported-foreign-function (xchangeactivepointergrab (:name "XChangeActivePointerGrab"))
    (dpy pointer-struct-display)
  (event-mask unsigned-int)
  (curs cursor)
  (time :unsigned-32bit))

(def-exported-foreign-function (xsetclosedownmode (:name "XSetCloseDownMode"))
    (dpy pointer-struct-display)
  (mode int))

(def-exported-foreign-function (xsetwindowcolormap (:name "XSetWindowColormap"))
    (dpy pointer-struct-display)
  (w window)
  (colormap colormap))

(def-exported-foreign-function (xchangegc (:name "XChangeGC"))
    (dpy pointer-struct-display)
  (gc gc)
  (valuemask unsigned-long)
  (values (:pointer xgcvalues)))

(def-exported-foreign-function (xchangekeyboardcontrol (:name "XChangeKeyboardControl"))
    (dpy pointer-struct-display)
  (mask unsigned-long)
  (value-list (:pointer xkeyboardcontrol)))

(def-exported-foreign-function (xchangepointercontrol (:name "XChangePointerControl"))
    (dpy pointer-struct-display)
  (do-acc int)
  (do-thresh int)
  (acc-numerator int)
  (acc-denominator int)
  (threshold int))

(def-exported-foreign-function (xchangeproperty (:name "XChangeProperty"))
    (dpy pointer-struct-display)
  (w window)
  (property :unsigned-32bit)
  (type :unsigned-32bit)
  (format int)
  (mode int)
  (data (:pointer unsigned-char))
  (nelements int))

(def-exported-foreign-function (xchangesaveset (:name "XChangeSaveSet"))
    (dpy pointer-struct-display)
  (win window)
  (mode int))

(def-exported-foreign-function (xaddtosaveset (:name "XAddToSaveSet"))
    (dpy pointer-struct-display)
  (win window))

(def-exported-foreign-function (xremovefromsaveset (:name "XRemoveFromSaveSet"))
    (dpy pointer-struct-display)
  (win window))

(def-exported-foreign-function (xchangewindowattributes (:name "XChangeWindowAttributes"))
    (dpy pointer-struct-display)
  (w window)
  (valuemask unsigned-long)
  (attributes (:pointer xsetwindowattributes)))

(def-exported-foreign-function (xresizewindow (:name "XResizeWindow"))
    (dpy pointer-struct-display)
  (w window)
  (width unsigned-int)
  (height unsigned-int))

(def-exported-foreign-function (xcheckifevent (:return-type int) (:name "XCheckIfEvent"))
    (dpy pointer-struct-display)
  (event (:pointer xevent))
  (predicate (:pointer :pointer))
  (arg (:pointer char)))

(def-exported-foreign-function (xcheckmaskevent (:return-type int) (:name "XCheckMaskEvent"))
    (dpy pointer-struct-display)
  (mask long)
  (event (:pointer xevent)))

(def-exported-foreign-function (xchecktypedevent (:return-type int) (:name "XCheckTypedEvent"))
    (dpy pointer-struct-display)
  (type int)
  (event (:pointer xevent)))

(def-exported-foreign-function (xchecktypedwindowevent (:return-type int) (:name "XCheckTypedWindowEvent"))
    (dpy pointer-struct-display)
  (w window)
  (type int)
  (event (:pointer xevent)))

(def-exported-foreign-function (xcheckwindowevent (:return-type int) (:name "XCheckWindowEvent"))
    (dpy pointer-struct-display)
  (w window)
  (mask long)
  (event (:pointer xevent)))

(def-exported-foreign-function (xcirculatesubwindows (:name "XCirculateSubwindows"))
    (dpy pointer-struct-display)
  (w window)
  (direction int))

(def-exported-foreign-function (xcirculatesubwindowsdown (:name "XCirculateSubwindowsDown"))
    (dpy pointer-struct-display)
  (w window))

(def-exported-foreign-function (xcirculatesubwindowsup (:name "XCirculateSubwindowsUp"))
    (dpy pointer-struct-display)
  (w window))

(def-exported-foreign-function (xclosedisplay (:name "XCloseDisplay"))
    (dpy pointer-struct-display))

(def-exported-foreign-function (xclearwindow (:name "XClearWindow"))
    (dpy pointer-struct-display)
  (w window))

(def-exported-foreign-function (xcleararea (:name "XClearArea"))
    (dpy pointer-struct-display)
  (w window)
  (x int)
  (y int)
  (width unsigned-int)
  (height unsigned-int)
  (exposures int))

(def-exported-foreign-function (xmoveresizewindow (:name "XMoveResizeWindow"))
    (dpy pointer-struct-display)
  (w window)
  (x int)
  (y int)
  (width unsigned-int)
  (height unsigned-int))

(def-exported-foreign-function (xconvertselection (:name "XConvertSelection"))
    (dpy pointer-struct-display)
  (selection :unsigned-32bit)
  (target :unsigned-32bit)
  (property :unsigned-32bit)
  (requestor window)
  (time :unsigned-32bit))

(def-exported-foreign-function (xcopyarea (:name "XCopyArea"))
    (dpy pointer-struct-display)
  (src-drawable drawable)
  (dst-drawable drawable)
  (gc gc)
  (src-x int)
  (src-y int)
  (width unsigned-int)
  (height unsigned-int)
  (dst-x int)
  (dst-y int))

(def-exported-foreign-function (xcopycolormapandfree (:name "XCopyColormapAndFree"))
    (dpy pointer-struct-display)
  (src-cmap colormap))

(def-exported-foreign-function (xcopygc (:name "XCopyGC"))
    (dpy pointer-struct-display)
  (mask unsigned-long)
  (srcgc gc)
  (destgc gc))

(def-exported-foreign-function (xcopyplane (:name "XCopyPlane"))
    (dpy pointer-struct-display)
  (src-drawable drawable)
  (dst-drawable drawable)
  (gc gc)
  (src-x int)
  (src-y int)
  (width unsigned-int)
  (height unsigned-int)
  (dst-x int)
  (dst-y int)
  (bit-plane unsigned-long))

(def-exported-foreign-function (xcreatecolormap (:return-type colormap) (:name "XCreateColormap"))
    (dpy pointer-struct-display)
  (w window)
  (visual (:pointer visual))
  (alloc int))

(def-exported-foreign-function (xcreatepixmapcursor (:return-type cursor) (:name "XCreatePixmapCursor"))
    (dpy pointer-struct-display)
  (source pixmap)
  (mask pixmap)
  (foreground (:pointer xcolor))
  (background (:pointer xcolor))
  (x unsigned-int)
  (y unsigned-int))

(def-exported-foreign-function (xcreategc (:return-type gc) (:name "XCreateGC"))
    (dpy pointer-struct-display)
  (d drawable)
  (valuemask unsigned-long)
  (values (:pointer xgcvalues)))

(def-exported-foreign-function (xgcontextfromgc (:return-type gcontext) (:name "XGContextFromGC"))
    (gc gc))

(def-exported-foreign-function (xcreateglyphcursor (:return-type cursor) (:name "XCreateGlyphCursor"))
    (dpy pointer-struct-display)
  (source-font font)
  (mask-font font)
  (source-char unsigned-int)
  (mask-char unsigned-int)
  (foreground (:pointer xcolor))
  (background (:pointer xcolor)))

(def-exported-foreign-function (xcreatepixmap (:return-type pixmap) (:name "XCreatePixmap"))
    (dpy pointer-struct-display)
  (d drawable)
  (width unsigned-int)
  (height unsigned-int)
  (depth unsigned-int))

(def-exported-foreign-function (xcreatesimplewindow (:return-type window) (:name "XCreateSimpleWindow"))
    (dpy pointer-struct-display)
  (parent window)
  (x int)
  (y int)
  (width unsigned-int)
  (height unsigned-int)
  (borderwidth unsigned-int)
  (border unsigned-long)
  (background unsigned-long))

(def-exported-foreign-function (xcreatefontcursor (:return-type cursor) (:name "XCreateFontCursor"))
    (dpy pointer-struct-display)
  (which unsigned-int))

(def-exported-foreign-function (xdefinecursor (:name "XDefineCursor"))
    (dpy pointer-struct-display)
  (w window)
  (cursor cursor))

(def-exported-foreign-function (xdeleteproperty (:name "XDeleteProperty"))
    (dpy pointer-struct-display)
  (window window)
  (property :unsigned-32bit))

(def-exported-foreign-function (xdestroysubwindows (:name "XDestroySubwindows"))
    (dpy pointer-struct-display)
  (win window))

(def-exported-foreign-function (xdestroywindow (:name "XDestroyWindow"))
    (dpy pointer-struct-display)
  (w window))

(def-exported-foreign-function (xdisplayname (:return-type (:pointer char)) (:name "XDisplayName"))
    (display (:pointer char)))


(def-exported-foreign-function (xgeterrortext (:name "XGetErrorText"))
    (dpy pointer-struct-display)
  (code int)
  (buffer (:pointer char))
  (nbytes int))

(def-exported-foreign-function (xgeterrordatabasetext (:name "XGetErrorDatabaseText"))
    (name (:pointer char))
  (type (:pointer char))
  (defaultp (:pointer char))
  (dpy pointer-struct-display)
  (buffer (:pointer char))
  (nbytes int))

(def-exported-foreign-function (xseterrorhandler (:name "XSetErrorHandler"))
    (handler callback-function-addr))

(def-exported-foreign-function (xsetioerrorhandler (:name "XSetIOErrorHandler"))
    (handler callback-function-addr))

(def-exported-foreign-function (xactivatescreensaver (:name "XActivateScreenSaver"))
    (dpy pointer-struct-display))

(def-exported-foreign-function (xresetscreensaver (:name "XResetScreenSaver"))
    (dpy pointer-struct-display))

(def-exported-foreign-function (xforcescreensaver (:return-type int) (:name "XForceScreenSaver"))
    (dpy pointer-struct-display)
  (mode int))

(def-exported-foreign-function (xfetchname (:return-type int) (:name "XFetchName"))
    (dpy pointer-struct-display)
  (w window)
  (name (:pointer (:pointer char))))

(def-exported-foreign-function (xgeticonname (:return-type int) (:name "XGetIconName"))
    (dpy pointer-struct-display)
  (w window)
  (icon-name (:pointer (:pointer char))))

(def-exported-foreign-function (xfillarc (:name "XFillArc"))
    (dpy pointer-struct-display)
  (d drawable)
  (gc gc)
  (x int)
  (y int)
  (width unsigned-int)
  (height unsigned-int)
  (angle1 int)
  (angle2 int))

(def-exported-foreign-function (xfillarcs (:name "XFillArcs"))
    (dpy pointer-struct-display)
  (d drawable)
  (gc gc)
  (arcs (:pointer xarc))
  (n-arcs int))

(def-exported-foreign-function (xfillpolygon (:name "XFillPolygon"))
    (dpy pointer-struct-display)
  (d drawable)
  (gc gc)
  (points (:pointer xpoint))
  (n-points int)
  (shape int)
  (mode int))

(def-exported-foreign-function (xfillrectangle (:name "XFillRectangle"))
    (dpy pointer-struct-display)
  (d drawable)
  (gc gc)
  (x int)
  (y int)
  (width unsigned-int)
  (height unsigned-int))

(def-exported-foreign-function (xfillrectangles (:name "XFillRectangles"))
    (dpy pointer-struct-display)
  (d drawable)
  (gc gc)
  (rectangles (:pointer xrectangle))
  (n-rects int))

(def-exported-foreign-function (xflush (:name "XFlush"))
    (dpy pointer-struct-display))

(def-exported-foreign-function (xloadqueryfont (:return-type (:pointer xfontstruct)) (:name "XLoadQueryFont"))
    (dpy pointer-struct-display)
  (name (:pointer char)))

(def-exported-foreign-function (xfreefont (:name "XFreeFont"))
    (dpy pointer-struct-display)
  (fs (:pointer xfontstruct)))

(def-exported-foreign-function (xqueryfont (:return-type (:pointer xfontstruct)) (:name "XQueryFont"))
    (dpy pointer-struct-display)
  (fid font))

(def-exported-foreign-function (xlistfontswithinfo (:return-type (:pointer (:pointer char))) (:name "XListFontsWithInfo"))
    (dpy pointer-struct-display)
  (pattern (:pointer char))
  (maxnames int)
  (actualcount (:pointer int))
  (info (:pointer (:pointer xfontstruct))))

(def-exported-foreign-function (xfreefontinfo (:name "XFreeFontInfo"))
    (names (:pointer (:pointer char)))
  (info (:pointer xfontstruct))
  (actualcount int))

(def-exported-foreign-function (xlistfonts (:return-type (:pointer (:pointer char))) (:name "XListFonts"))
    (dpy pointer-struct-display)
  (pattern (:pointer char))
  (maxnames int)
  (actualcount (:pointer int)))

(def-exported-foreign-function (xfreefontnames (:name "XFreeFontNames"))
    (list (:pointer (:pointer char))))

(def-exported-foreign-function (xfreecolormap (:name "XFreeColormap"))
    (dpy pointer-struct-display)
  (cmap colormap))

(def-exported-foreign-function (xfreecolors (:name "XFreeColors"))
    (dpy pointer-struct-display)
  (cmap colormap)
  (pixels (:pointer unsigned-long))
  (npixels int)
  (planes unsigned-long))

(def-exported-foreign-function (xfreecursor (:name "XFreeCursor"))
    (dpy pointer-struct-display)
  (cursor cursor))

(def-exported-foreign-function (xfreegc (:name "XFreeGC"))
    (dpy pointer-struct-display)
  (gc gc))

(def-exported-foreign-function (xfreepixmap (:name "XFreePixmap"))
    (dpy pointer-struct-display)
  (pixmap pixmap))

(def-exported-foreign-function (xsetarcmode (:name "XSetArcMode"))
    (dpy pointer-struct-display)
  (gc gc)
  (arc-mode int))

(def-exported-foreign-function (xsetfillrule (:name "XSetFillRule"))
    (dpy pointer-struct-display)
  (gc gc)
  (fill-rule int))

(def-exported-foreign-function (xsetfillstyle (:name "XSetFillStyle"))
    (dpy pointer-struct-display)
  (gc gc)
  (fill-style int))

(def-exported-foreign-function (xsetgraphicsexposures (:name "XSetGraphicsExposures"))
    (dpy pointer-struct-display)
  (gc gc)
  (graphics-exposures int))

(def-exported-foreign-function (xsetsubwindowmode (:name "XSetSubwindowMode"))
    (dpy pointer-struct-display)
  (gc gc)
  (subwindow-mode int))

(def-exported-foreign-function (xgetatomname (:return-type (:pointer char)) (:name "XGetAtomName"))
    (dpy pointer-struct-display)
  (atom :unsigned-32bit))

(def-exported-foreign-function (xallocnamedcolor (:return-type int) (:name "XAllocNamedColor"))
    (dpy pointer-struct-display)
  (cmap colormap)
  (colorname (:pointer char))
  (hard-def (:pointer xcolor))
  (exact-def (:pointer xcolor)))

(def-exported-foreign-function (xgetfontpath (:return-type (:pointer (:pointer char))) (:name "XGetFontPath"))
    (dpy pointer-struct-display)
  (npaths (:pointer int)))

(def-exported-foreign-function (xfreefontpath (:name "XFreeFontPath"))
    (list (:pointer (:pointer char))))

(def-exported-foreign-function (xgetfontproperty (:return-type int) (:name "XGetFontProperty"))
    (fs (:pointer xfontstruct))
  (name :unsigned-32bit)
  (valueptr (:pointer unsigned-long)))

(def-exported-foreign-function (xgetgeometry (:return-type int) (:name "XGetGeometry"))
    (dpy pointer-struct-display)
  (d drawable)
  (root (:pointer window))
  (x (:pointer int))
  (y (:pointer int))
  (width (:pointer unsigned-int))
  (height (:pointer unsigned-int))
  (borderwidth (:pointer unsigned-int))
  (depth (:pointer unsigned-int)))

(def-exported-foreign-function (xalloccolor (:return-type int) (:name "XAllocColor"))
    (dpy pointer-struct-display)
  (cmap colormap)
  (def (:pointer xcolor)))

(def-exported-foreign-function (xgetinputfocus (:name "XGetInputFocus"))
    (dpy pointer-struct-display)
  (focus (:pointer window))
  (revert-to (:pointer int)))

(def-exported-foreign-function (xgetimage (:return-type (:pointer ximage)) (:name "XGetImage"))
    (dpy pointer-struct-display)
  (d drawable)
  (x int)
  (y int)
  (width unsigned-int)
  (height unsigned-int)
  (plane-mask unsigned-long)
  (format int))

(def-exported-foreign-function (xgetsubimage (:return-type (:pointer ximage)) (:name "XGetSubImage"))
    (dpy pointer-struct-display)
  (d drawable)
  (x int)
  (y int)
  (width unsigned-int)
  (height unsigned-int)
  (plane-mask unsigned-long)
  (format int)
  (dest-image (:pointer ximage))
  (dest-x int)
  (dest-y int))

(def-exported-foreign-function (xgetkeyboardcontrol (:name "XGetKeyboardControl"))
    (dpy pointer-struct-display)
  (state (:pointer xkeyboardstate)))

(def-exported-foreign-function (xgetmotionevents (:return-type (:pointer xtimecoord)) (:name "XGetMotionEvents"))
    (dpy pointer-struct-display)
  (start :unsigned-32bit)
  (stop :unsigned-32bit)
  (w window)
  (nevents (:pointer int)))

(def-exported-foreign-function (xgetpointercontrol (:name "XGetPointerControl"))
    (dpy pointer-struct-display)
  (accel-numer (:pointer int))
  (accel-denom (:pointer int))
  (threshold (:pointer int)))

(def-exported-foreign-function (xgetpointermapping (:return-type int) (:name "XGetPointerMapping"))
    (dpy pointer-struct-display)
  (map (:pointer unsigned-char))
  (nmaps int))

(def-exported-foreign-function (xgetkeyboardmapping (:return-type (:pointer keysym)) (:name "XGetKeyboardMapping"))
    (dpy pointer-struct-display)
  (first-keycode :character) ;; (first-keycode keycode)
  (count int)
  (keysyms-per-keycode (:pointer int)))

(def-exported-foreign-function (xgetwindowproperty (:return-type int) (:name "XGetWindowProperty"))
    (dpy pointer-struct-display)
  (w window)
  (property :unsigned-32bit)
  (offset long)
  (length long)
  (delete int)
  (req-type :unsigned-32bit)
  (actual-type (:pointer atom))
  (actual-format (:pointer int))
  (nitems (:pointer unsigned-long))
  (bytesafter (:pointer unsigned-long))
  (prop (:pointer (:pointer unsigned-char))))

(def-exported-foreign-function (xgetselectionowner (:return-type window) (:name "XGetSelectionOwner"))
    (dpy pointer-struct-display)
  (selection :unsigned-32bit))

(def-exported-foreign-function (xgetscreensaver (:name "XGetScreenSaver"))
    (dpy pointer-struct-display)
  (timeout (:pointer int))
  (interval (:pointer int))
  (prefer-blanking (:pointer int))
  (allow-exp (:pointer int)))

(def-exported-foreign-function (xgetwindowattributes (:return-type int) (:name "XGetWindowAttributes"))
    (dpy pointer-struct-display)
  (w window)
  (att (:pointer xwindowattributes)))

(def-exported-foreign-function (xgrabbutton (:name "XGrabButton"))
    (dpy pointer-struct-display)
  (modifiers unsigned-int)
  (button unsigned-int)
  (grab-window window)
  (owner-events int)
  (event-mask unsigned-int)
  (pointer-mode int)
  (keyboard-mode int)
  (confine-to window)
  (curs cursor))

(def-exported-foreign-function (xgrabkey (:name "XGrabKey"))
    (dpy pointer-struct-display)
  (key int)
  (modifiers unsigned-int)
  (grab-window window)
  (owner-events int)
  (pointer-mode int)
  (keyboard-mode int))

(def-exported-foreign-function (xgrabkeyboard (:return-type int) (:name "XGrabKeyboard"))
    (dpy pointer-struct-display)
  (window window)
  (ownerevents int)
  (pointermode int)
  (keyboardmode int)
  (time :unsigned-32bit))

(def-exported-foreign-function (xgrabpointer (:return-type int) (:name "XGrabPointer"))
    (dpy pointer-struct-display)
  (grab-window window)
  (owner-events int)
  (event-mask unsigned-int)
  (pointer-mode int)
  (keyboard-mode int)
  (confine-to window)
  (curs cursor)
  (time :unsigned-32bit))

(def-exported-foreign-function (xgrabserver (:name "XGrabServer"))
    (dpy pointer-struct-display))

(def-exported-foreign-function (xaddhost (:name "XAddHost"))
    (dpy pointer-struct-display)
  (host (:pointer xhostaddress)))

(def-exported-foreign-function (xremovehost (:name "XRemoveHost"))
    (dpy pointer-struct-display)
  (host (:pointer xhostaddress)))

(def-exported-foreign-function (xaddhosts (:name "XAddHosts"))
    (dpy pointer-struct-display)
  (hosts (:pointer xhostaddress))
  (n int))

(def-exported-foreign-function (xremovehosts (:name "XRemoveHosts"))
    (dpy pointer-struct-display)
  (hosts (:pointer xhostaddress))
  (n int))

(def-exported-foreign-function (xifevent (:name "XIfEvent"))
    (dpy pointer-struct-display)
  (event (:pointer xevent))
  (predicate (:pointer :pointer))
  (arg (:pointer char)))

(def-exported-foreign-function (xinitextension (:return-type (:pointer xextcodes)) (:name "XInitExtension"))
    (dpy pointer-struct-display)
  (name (:pointer char)))

(def-exported-foreign-function (xaddextension (:return-type (:pointer xextcodes)) (:name "XAddExtension"))
    (dpy pointer-struct-display))

(def-exported-foreign-function (xeheadofextensionlist (:return-type (:pointer (:pointer xextdata))) (:name "XEHeadOfExtensionList"))
    (object xedataobject))

(def-exported-foreign-function (xfindonextensionlist (:return-type (:pointer xextdata)) (:name "XFindOnExtensionList"))
    (structure (:pointer (:pointer xextdata)))
  (number int))

(def-exported-foreign-function (xesetcreategc (:return-type (:pointer :pointer)) (:name "XESetCreateGC"))
    (dpy pointer-struct-display)
  (extension int)
  (proc (:pointer :pointer)))

(def-exported-foreign-function (xesetcopygc (:return-type (:pointer :pointer)) (:name "XESetCopyGC"))
    (dpy pointer-struct-display)
  (extension int)
  (proc (:pointer :pointer)))

(def-exported-foreign-function (xesetflushgc (:return-type (:pointer :pointer)) (:name "XESetFlushGC"))
    (dpy pointer-struct-display)
  (extension int)
  (proc (:pointer :pointer)))

(def-exported-foreign-function (xesetfreegc (:return-type (:pointer :pointer)) (:name "XESetFreeGC"))
    (dpy pointer-struct-display)
  (extension int)
  (proc (:pointer :pointer)))

(def-exported-foreign-function (xesetcreatefont (:return-type (:pointer :pointer)) (:name "XESetCreateFont"))
    (dpy pointer-struct-display)
  (extension int)
  (proc (:pointer :pointer)))

(def-exported-foreign-function (xesetfreefont (:return-type (:pointer :pointer)) (:name "XESetFreeFont"))
    (dpy pointer-struct-display)
  (extension int)
  (proc (:pointer :pointer)))

(def-exported-foreign-function (xesetclosedisplay (:return-type (:pointer :pointer)) (:name "XESetCloseDisplay"))
    (dpy pointer-struct-display)
  (extension int)
  (proc (:pointer :pointer)))

(def-exported-foreign-function (xesetwiretoevent (:return-type (:pointer :pointer)) (:name "XESetWireToEvent"))
    (dpy pointer-struct-display)
  (proc (:pointer :pointer))
  (event-number int))

(def-exported-foreign-function (xeseteventtowire (:return-type (:pointer :pointer)) (:name "XESetEventToWire"))
    (dpy pointer-struct-display)
  (proc (:pointer :pointer))
  (event-number int))

(def-exported-foreign-function (xeseterror (:return-type (:pointer :pointer)) (:name "XESetError"))
    (dpy pointer-struct-display)
  (extension int)
  (proc (:pointer :pointer)))

(def-exported-foreign-function (xeseterrorstring (:return-type (:pointer :pointer)) (:name "XESetErrorString"))
    (dpy pointer-struct-display)
  (extension int)
  (proc (:pointer :pointer)))

(def-exported-foreign-function (xinstallcolormap (:name "XInstallColormap"))
    (dpy pointer-struct-display)
  (cmap colormap))

(def-exported-foreign-function (xinternatom (:return-type :unsigned-32bit) (:name "XInternAtom"))
    (dpy pointer-struct-display)
  (name (:pointer char))
  (onlyifexists int))

(def-exported-foreign-function (xrefreshkeyboardmapping (:name "XRefreshKeyboardMapping"))
    (event (:pointer xmappingevent)))

#+ignore
(def-exported-foreign-function (xusekeymap (:return-type int) (:name "XUseKeymap"))
    (filename (:pointer char)))

(def-exported-foreign-function (xrebindkeysym (:name "XRebindKeysym"))
    (dpy pointer-struct-display)
  (keysym keysym)
  (mlist (:pointer keysym))
  (nm int)
  (str (:pointer unsigned-char))
  (nbytes int))

(def-exported-foreign-function (xkillclient (:name "XKillClient"))
    (dpy pointer-struct-display)
  (resource xid))

(def-exported-foreign-function (xlisthosts (:return-type (:pointer xhostaddress)) (:name "XListHosts"))
    (dpy pointer-struct-display)
  (nhosts (:pointer int))
  (enabled (:pointer int)))

(def-exported-foreign-function (xlistinstalledcolormaps (:return-type (:pointer colormap)) (:name "XListInstalledColormaps"))
    (dpy pointer-struct-display)
  (win window)
  (n (:pointer int)))

(def-exported-foreign-function (xlistproperties (:return-type (:pointer atom)) (:name "XListProperties"))
    (dpy pointer-struct-display)
  (window window)
  (n-props (:pointer int)))

(def-exported-foreign-function (xlistextensions (:return-type (:pointer (:pointer char))) (:name "XListExtensions"))
    (dpy pointer-struct-display)
  (nextensions (:pointer int)))

(def-exported-foreign-function (xfreeextensionlist (:name "XFreeExtensionList"))
    (list (:pointer (:pointer char))))

(def-exported-foreign-function (xloadfont (:return-type font) (:name "XLoadFont"))
    (dpy pointer-struct-display)
  (name (:pointer char)))

(def-exported-foreign-function (xlookupcolor (:return-type int) (:name "XLookupColor"))
    (dpy pointer-struct-display)
  (cmap colormap)
  (spec (:pointer char))
  (def (:pointer xcolor))
  (scr (:pointer xcolor)))

(def-exported-foreign-function (xlowerwindow (:name "XLowerWindow"))
    (dpy pointer-struct-display)
  (w window))

(def-exported-foreign-function (xconnectionnumber (:return-type int) (:name "XConnectionNumber"))
    (dpy pointer-struct-display))

(def-exported-foreign-function (xrootwindow (:return-type window) (:name "XRootWindow"))
    (dpy pointer-struct-display)
  (scr int))


(def-exported-foreign-function (xdefaultscreen (:return-type int) (:name "XDefaultScreen"))
    (dpy pointer-struct-display))

;; (def-exported-foreign-function (xdefaultscreen (:return-type int) (:name "XDefaultScreen"))
;;     (dpy pointer-struct-display))

;; (defmethod cffi::translate-to-foreign (object (type x11::display-type))
;;   (ff-wrapper::foreign-pointer-address object))

;; (CFFI:DEFCFUN (XDEFAULTSCREEN "XDefaultScreen")
;;        INT
;;      (DPY (:POINTER (:STRUCT DISPLAY))))

(def-exported-foreign-function (xdefaultrootwindow (:return-type window) (:name "XDefaultRootWindow"))
    (dpy pointer-struct-display))

(def-exported-foreign-function (xdefaultvisual (:return-type (:pointer visual)) (:name "XDefaultVisual"))
    (dpy pointer-struct-display)
  (scr int))

(def-exported-foreign-function (xdefaultgc (:return-type gc) (:name "XDefaultGC"))
    (dpy pointer-struct-display)
  (scr int))

(def-exported-foreign-function (xblackpixel (:return-type unsigned-long) (:name "XBlackPixel"))
    (dpy pointer-struct-display)
  (scr int))

(def-exported-foreign-function (xwhitepixel (:return-type unsigned-long) (:name "XWhitePixel"))
    (dpy pointer-struct-display)
  (scr int))

(def-exported-foreign-function (xallplanes (:return-type unsigned-long) (:name "XAllPlanes")) )

(def-exported-foreign-function (xqlength (:return-type int) (:name "XQLength"))
    (dpy pointer-struct-display))

(def-exported-foreign-function (xdisplaywidth (:return-type int) (:name "XDisplayWidth"))
    (dpy pointer-struct-display)
  (scr int))

(def-exported-foreign-function (xdisplayheight (:return-type int) (:name "XDisplayHeight"))
    (dpy pointer-struct-display)
  (scr int))

(def-exported-foreign-function (xdisplaywidthmm (:return-type int) (:name "XDisplayWidthMM"))
    (dpy pointer-struct-display)
  (scr int))

(def-exported-foreign-function (xdisplayheightmm (:return-type int) (:name "XDisplayHeightMM"))
    (dpy pointer-struct-display)
  (scr int))

(def-exported-foreign-function (xdisplayplanes (:return-type int) (:name "XDisplayPlanes"))
    (dpy pointer-struct-display)
  (scr int))

(def-exported-foreign-function (xdisplaycells (:return-type int) (:name "XDisplayCells"))
    (dpy pointer-struct-display)
  (scr int))

(def-exported-foreign-function (xscreencount (:return-type int) (:name "XScreenCount"))
    (dpy pointer-struct-display))

(def-exported-foreign-function (xservervendor (:return-type (:pointer char)) (:name "XServerVendor"))
    (dpy pointer-struct-display))

(def-exported-foreign-function (xprotocolversion (:return-type int) (:name "XProtocolVersion"))
    (dpy pointer-struct-display))

(def-exported-foreign-function (xprotocolrevision (:return-type int) (:name "XProtocolRevision"))
    (dpy pointer-struct-display))

(def-exported-foreign-function (xvendorrelease (:return-type int) (:name "XVendorRelease"))
    (dpy pointer-struct-display))

(def-exported-foreign-function (xdisplaystring (:return-type (:pointer char)) (:name "XDisplayString"))
    (dpy pointer-struct-display))

(def-exported-foreign-function (xdefaultdepth (:return-type int) (:name "XDefaultDepth"))
    (dpy pointer-struct-display)
  (scr int))

(def-exported-foreign-function (xdefaultcolormap (:return-type colormap) (:name "XDefaultColormap"))
    (dp pointer-struct-display)
  (scr int))

(def-exported-foreign-function (xbitmapunit (:return-type int) (:name "XBitmapUnit"))
    (dpy pointer-struct-display))

(def-exported-foreign-function (xbitmapbitorder (:return-type int) (:name "XBitmapBitOrder"))
    (dpy pointer-struct-display))

(def-exported-foreign-function (xbitmappad (:return-type int) (:name "XBitmapPad"))
    (dpy pointer-struct-display))

(def-exported-foreign-function (ximagebyteorder (:return-type int) (:name "XImageByteOrder"))
    (dpy pointer-struct-display))

(def-exported-foreign-function (xnextrequest (:return-type unsigned-long) (:name "XNextRequest"))
    (dpy pointer-struct-display))

(def-exported-foreign-function (xlastknownrequestprocessed (:return-type unsigned-long) (:name "XLastKnownRequestProcessed"))
    (dpy pointer-struct-display))

(def-exported-foreign-function (xscreenofdisplay (:return-type pointer-struct-screen) (:name "XScreenOfDisplay"))
    (dpy pointer-struct-display)
  (scr int))

(def-exported-foreign-function (xdefaultscreenofdisplay (:return-type pointer-struct-screen) (:name "XDefaultScreenOfDisplay"))
    (dpy pointer-struct-display))

(def-exported-foreign-function (xdisplayofscreen (:return-type pointer-struct-display) (:name "XDisplayOfScreen"))
    (s pointer-struct-screen))

(def-exported-foreign-function (xrootwindowofscreen (:return-type window) (:name "XRootWindowOfScreen"))
    (s pointer-struct-screen))

(def-exported-foreign-function (xblackpixelofscreen (:return-type unsigned-long) (:name "XBlackPixelOfScreen"))
    (s pointer-struct-screen))

(def-exported-foreign-function (xwhitepixelofscreen (:return-type unsigned-long) (:name "XWhitePixelOfScreen"))
    (s pointer-struct-screen))

(def-exported-foreign-function (xdefaultcolormapofscreen (:return-type colormap) (:name "XDefaultColormapOfScreen"))
    (s pointer-struct-screen))

(def-exported-foreign-function (xdefaultdepthofscreen (:return-type int) (:name "XDefaultDepthOfScreen"))
    (s pointer-struct-screen))

(def-exported-foreign-function (xdefaultgcofscreen (:return-type gc) (:name "XDefaultGCOfScreen"))
    (s pointer-struct-screen))

(def-exported-foreign-function (xdefaultvisualofscreen (:return-type (:pointer visual)) (:name "XDefaultVisualOfScreen"))
    (s pointer-struct-screen))

(def-exported-foreign-function (xwidthofscreen (:return-type int) (:name "XWidthOfScreen"))
    (s pointer-struct-screen))

(def-exported-foreign-function (xheightofscreen (:return-type int) (:name "XHeightOfScreen"))
    (s pointer-struct-screen))

(def-exported-foreign-function (xwidthmmofscreen (:return-type int) (:name "XWidthMMOfScreen"))
    (s pointer-struct-screen))

(def-exported-foreign-function (xheightmmofscreen (:return-type int) (:name "XHeightMMOfScreen"))
    (s pointer-struct-screen))

(def-exported-foreign-function (xplanesofscreen (:return-type int) (:name "XPlanesOfScreen"))
    (s pointer-struct-screen))

(def-exported-foreign-function (xcellsofscreen (:return-type int) (:name "XCellsOfScreen"))
    (s pointer-struct-screen))

(def-exported-foreign-function (xmincmapsofscreen (:return-type int) (:name "XMinCmapsOfScreen"))
    (s pointer-struct-screen))

(def-exported-foreign-function (xmaxcmapsofscreen (:return-type int) (:name "XMaxCmapsOfScreen"))
    (s pointer-struct-screen))

(def-exported-foreign-function (xdoessaveunders (:return-type int) (:name "XDoesSaveUnders"))
    (s pointer-struct-screen))

(def-exported-foreign-function (xdoesbackingstore (:return-type int) (:name "XDoesBackingStore"))
    (s pointer-struct-screen))

(def-exported-foreign-function (xeventmaskofscreen (:return-type long) (:name "XEventMaskOfScreen"))
    (s pointer-struct-screen))

(def-exported-foreign-function (xnoop (:name "XNoOp"))
    (dpy pointer-struct-display))

(def-exported-foreign-function (xparsecolor (:return-type int)
					    (:name "XParseColor"))
    (display pointer-struct-display)
  (colormap colormap)
  (spec (:pointer char))
  (exact-def-return (:pointer xcolor)))

(def-exported-foreign-function (xparsegeometry (:return-type int)
					       (:name "XParseGeometry"))
    (parsestring (:pointer char))
  (x-return (:pointer int))
  (y-return (:pointer int))
  (width-return (:pointer unsigned-int))
  (height-return (:pointer unsigned-int)))

(def-exported-foreign-function (xmapraised (:name "XMapRaised"))
    (dpy pointer-struct-display)
  (w window))

(def-exported-foreign-function (xmapsubwindows (:name "XMapSubwindows"))
    (dpy pointer-struct-display)
  (win window))

(def-exported-foreign-function (xmapwindow (:name "XMapWindow"))
    (dpy pointer-struct-display)
  (win window))

(def-exported-foreign-function (xmaskevent (:name "XMaskEvent"))
    (dpy pointer-struct-display)
  (mask long)
  (event (:pointer xevent)))

(def-exported-foreign-function (xmaxrequestsize (:return-type long) (:name "XMaxRequestSize"))
    (dpy pointer-struct-display))

(def-exported-foreign-function (xresourcemanagerstring (:return-type (:pointer char)) (:name "XResourceManagerString"))
    (dpy pointer-struct-display))

(def-exported-foreign-function (xdisplaymotionbuffersize (:return-type unsigned-long) (:name "XDisplayMotionBufferSize"))
    (dpy pointer-struct-display))

(def-exported-foreign-function (xdisplaykeycodes (:name "XDisplayKeycodes"))
    (dpy pointer-struct-display)
  (min-keycode-return (:pointer int))
  (max-keycode-return (:pointer int)))

(def-exported-foreign-function (xvisualidfromvisual (:return-type visualid) (:name "XVisualIDFromVisual"))
    (visual (:pointer visual)))

(def-exported-foreign-function (xgetmodifiermapping (:return-type (:pointer xmodifierkeymap)) (:name "XGetModifierMapping"))
    (dpy pointer-struct-display))

(def-exported-foreign-function (xsetmodifiermapping (:return-type int) (:name "XSetModifierMapping"))
    (dpy pointer-struct-display)
  (modifier-map (:pointer xmodifierkeymap)))

(def-exported-foreign-function (xnewmodifiermap (:return-type (:pointer xmodifierkeymap)) (:name "XNewModifiermap"))
    (keyspermodifier int))

(def-exported-foreign-function (xfreemodifiermap (:name "XFreeModifiermap"))
    (map (:pointer xmodifierkeymap)))

(def-exported-foreign-function (xinsertmodifiermapentry (:return-type (:pointer xmodifierkeymap)) (:name "XInsertModifiermapEntry"))
    (map (:pointer xmodifierkeymap))
  (keysym :character) ;; (keysym keycode)
  (modifier int))

(def-exported-foreign-function (xdeletemodifiermapentry (:return-type (:pointer xmodifierkeymap)) (:name "XDeleteModifiermapEntry"))
    (map (:pointer xmodifierkeymap))
  (keysym :character) ;; (keysym keycode)
  (modifier int))

(def-exported-foreign-function (xmovewindow (:name "XMoveWindow"))
    (dpy pointer-struct-display)
  (w window)
  (x int)
  (y int))

(def-exported-foreign-function (xnextevent (:name "XNextEvent"))
    (dpy pointer-struct-display)
  (event (:pointer xevent)))

(def-exported-foreign-function (xopendisplay (:return-type pointer-struct-display) (:name "XOpenDisplay"))
    (display (:pointer char)))

(def-exported-foreign-function (xpeekevent (:name "XPeekEvent"))
    (dpy pointer-struct-display)
  (event (:pointer xevent)))

(def-exported-foreign-function (xpeekifevent (:name "XPeekIfEvent"))
    (dpy pointer-struct-display)
  (event (:pointer xevent))
  (predicate (:pointer :pointer))
  (arg (:pointer char)))

(def-exported-foreign-function (xeventsqueued (:return-type int) (:name "XEventsQueued"))
    (dpy pointer-struct-display)
  (mode int))

(def-exported-foreign-function (xpending (:return-type fixnum-int) (:name "XPending"))
    (dpy pointer-struct-display))

(def-exported-foreign-function (xsetwindowbackgroundpixmap (:name "XSetWindowBackgroundPixmap"))
    (dpy pointer-struct-display)
  (w window)
  (pixmap pixmap))

(def-exported-foreign-function (xsetwindowborderpixmap (:name "XSetWindowBorderPixmap"))
    (dpy pointer-struct-display)
  (w window)
  (pixmap pixmap))

(def-exported-foreign-function (xputbackevent (:name "XPutBackEvent"))
    (dpy pointer-struct-display)
  (event (:pointer xevent)))

(def-exported-foreign-function (xputimage (:name "XPutImage"))
    (dpy pointer-struct-display)
  (d drawable)
  (gc gc)
  (image (:pointer ximage))
  (x int)
  (y int)
  (req-width unsigned-int)
  (req-height unsigned-int)
  (req-xoffset int)
  (req-yoffset int))

(def-exported-foreign-function (xquerybestsize (:return-type int) (:name "XQueryBestSize"))
    (dpy pointer-struct-display)
  (class int)
  (drawable drawable)
  (width unsigned-int)
  (height unsigned-int)
  (ret-width (:pointer unsigned-int))
  (ret-height (:pointer unsigned-int)))

(def-exported-foreign-function (xquerycolor (:name "XQueryColor"))
    (dpy pointer-struct-display)
  (cmap colormap)
  (def (:pointer xcolor)))

(def-exported-foreign-function (xquerycolors (:name "XQueryColors"))
    (dpy pointer-struct-display)
  (cmap colormap)
  (defs (:pointer xcolor))
  (ncolors int))

(def-exported-foreign-function (xquerybestcursor (:return-type int) (:name "XQueryBestCursor"))
    (dpy pointer-struct-display)
  (drawable drawable)
  (width unsigned-int)
  (height unsigned-int)
  (ret-width (:pointer unsigned-int))
  (ret-height (:pointer unsigned-int)))

(def-exported-foreign-function (xqueryextension (:return-type int) (:name "XQueryExtension"))
    (dpy pointer-struct-display)
  (name (:pointer char))
  (major-opcode (:pointer int))
  (first-event (:pointer int))
  (first-error (:pointer int)))

(def-exported-foreign-function (xquerykeymap (:name "XQueryKeymap"))
    (dpy pointer-struct-display)
  (keys (:array char (32))))

(def-exported-foreign-function (xquerypointer (:return-type int) (:name "XQueryPointer"))
    (dpy pointer-struct-display)
  (w window)
  (root (:pointer window))
  (child (:pointer window))
  (root-x (:pointer int))
  (root-y (:pointer int))
  (win-x (:pointer int))
  (win-y (:pointer int))
  (mask (:pointer unsigned-int)))

(def-exported-foreign-function (xquerybeststipple (:return-type int) (:name "XQueryBestStipple"))
    (dpy pointer-struct-display)
  (drawable drawable)
  (width unsigned-int)
  (height unsigned-int)
  (ret-width (:pointer unsigned-int))
  (ret-height (:pointer unsigned-int)))

(def-exported-foreign-function (xquerytextextents16 (:name "XQueryTextExtents16"))
    (dpy pointer-struct-display)
  (fid font)
  (string (:pointer xchar2b))
  (nchars int)
  (dir (:pointer int))
  (font-ascent (:pointer int))
  (font-descent (:pointer int))
  (overall (:pointer xcharstruct)))

(def-exported-foreign-function (xquerytextextents (:name "XQueryTextExtents"))
    (dpy pointer-struct-display)
  (fid font)
  (string (:pointer char))
  (nchars int)
  (dir (:pointer int))
  (font-ascent (:pointer int))
  (font-descent (:pointer int))
  (overall (:pointer xcharstruct)))

(def-exported-foreign-function (xquerybesttile (:return-type int) (:name "XQueryBestTile"))
    (dpy pointer-struct-display)
  (drawable drawable)
  (width unsigned-int)
  (height unsigned-int)
  (ret-width (:pointer unsigned-int))
  (ret-height (:pointer unsigned-int)))

(def-exported-foreign-function (xquerytree (:return-type int) (:name "XQueryTree"))
    (dpy pointer-struct-display)
  (w window)
  (root (:pointer window))
  (parent (:pointer window))
  (children (:pointer (:pointer window)))
  (nchildren (:pointer unsigned-int)))

(def-exported-foreign-function (xraisewindow (:name "XRaiseWindow"))
    (dpy pointer-struct-display)
  (w window))

(def-exported-foreign-function (xrecolorcursor (:name "XRecolorCursor"))
    (dpy pointer-struct-display)
  (cursor cursor)
  (foreground (:pointer xcolor))
  (background (:pointer xcolor)))

(def-exported-foreign-function (xconfigurewindow (:name "XConfigureWindow"))
    (dpy pointer-struct-display)
  (w window)
  (mask unsigned-int)
  (changes (:pointer xwindowchanges)))

(def-exported-foreign-function (xreparentwindow (:name "XReparentWindow"))
    (dpy pointer-struct-display)
  (w window)
  (p window)
  (x int)
  (y int))

(def-exported-foreign-function (xrestackwindows (:name "XRestackWindows"))
    (dpy pointer-struct-display)
  (windows (:pointer window))
  (n int))

(def-exported-foreign-function (xrotatewindowproperties (:name "XRotateWindowProperties"))
    (dpy pointer-struct-display)
  (w window)
  (properties (:pointer atom))
  (nprops int)
  (npositions int))

(def-exported-foreign-function (xselectinput (:name "XSelectInput"))
    (dpy pointer-struct-display)
  (w window)
  (mask long))

(def-exported-foreign-function (xsendevent (:return-type int) (:name "XSendEvent"))
    (dpy pointer-struct-display)
  (w window)
  (propagate int)
  (event-mask long)
  (event (:pointer xevent)))

(def-exported-foreign-function (xsetbackground (:name "XSetBackground"))
    (dpy pointer-struct-display)
  (gc gc)
  (background unsigned-long))

(def-exported-foreign-function (xsetcliprectangles (:name "XSetClipRectangles"))
    (dpy pointer-struct-display)
  (gc gc)
  (clip-x-origin int)
  (clip-y-origin int)
  (rectangles (:pointer xrectangle))
  (n int)
  (ordering int))

(def-exported-foreign-function (xsetclipmask (:name "XSetClipMask"))
    (dpy pointer-struct-display)
  (gc gc)
  (mask pixmap))

(def-exported-foreign-function (xsetcliporigin (:name "XSetClipOrigin"))
    (dpy pointer-struct-display)
  (gc gc)
  (xorig int)
  (yorig int))

(def-exported-foreign-function (xsetdashes (:name "XSetDashes"))
    (dpy pointer-struct-display)
  (gc gc)
  (dash-offset int)
  (list (:pointer char))
  (n int))

(def-exported-foreign-function (xsetfontpath (:name "XSetFontPath"))
    (dpy pointer-struct-display)
  (directories (:pointer (:pointer char)))
  (ndirs int))

(def-exported-foreign-function (xsetfont (:name "XSetFont"))
    (dpy pointer-struct-display)
  (gc gc)
  (font font))

(def-exported-foreign-function (xsetforeground (:name "XSetForeground"))
    (dpy pointer-struct-display)
  (gc gc)
  (foreground unsigned-long))

(def-exported-foreign-function (xsetfunction (:name "XSetFunction"))
    (dpy pointer-struct-display)
  (gc gc)
  (function int))

(def-exported-foreign-function (xsetcommand (:name "XSetCommand"))
    (dpy pointer-struct-display)
  (w window)
  (argv (:pointer (:pointer char)))
  (argc int))

(def-exported-foreign-function (xsetinputfocus (:name "XSetInputFocus"))
    (dpy pointer-struct-display)
  (focus window)
  (revert-to int)
  (time :unsigned-32bit))

(def-exported-foreign-function (xsetlineattributes (:name "XSetLineAttributes"))
    (dpy pointer-struct-display)
  (gc gc)
  (linewidth unsigned-int)
  (linestyle int)
  (capstyle int)
  (joinstyle int))

(def-exported-foreign-function (xsetplanemask (:name "XSetPlaneMask"))
    (dpy pointer-struct-display)
  (gc gc)
  (planemask unsigned-long))

(def-exported-foreign-function (xsetpointermapping (:return-type int) (:name "XSetPointerMapping"))
    (dpy pointer-struct-display)
  (map (:pointer unsigned-char))
  (nmaps int))

(def-exported-foreign-function (xchangekeyboardmapping (:name "XChangeKeyboardMapping"))
    (dpy pointer-struct-display)
  (first-keycode int)
  (keysyms-per-keycode int)
  (keysyms (:pointer keysym))
  (nkeycodes int))

(def-exported-foreign-function (xkeycodetokeysym (:return-type int)
                                                 (:name "XKeycodeToKeysym"))
    (dpy pointer-struct-display)
  (keycode int)
  (index int))

(def-exported-foreign-function (xsetselectionowner (:name "XSetSelectionOwner"))
    (dpy pointer-struct-display)
  (selection :unsigned-32bit)
  (owner window)
  (time :unsigned-32bit))

(def-exported-foreign-function (xsetscreensaver (:name "XSetScreenSaver"))
    (dpy pointer-struct-display)
  (timeout int)
  (interval int)
  (prefer-blank int)
  (allow-exp int))

(def-exported-foreign-function (xsetstate (:name "XSetState"))
    (dpy pointer-struct-display)
  (gc gc)
  (function int)
  (planemask unsigned-long)
  (foreground unsigned-long)
  (background unsigned-long))

(def-exported-foreign-function (xsetstipple (:name "XSetStipple"))
    (dpy pointer-struct-display)
  (gc gc)
  (stipple pixmap))

(def-exported-foreign-function (xsettsorigin (:name "XSetTSOrigin"))
    (dpy pointer-struct-display)
  (gc gc)
  (x int)
  (y int))

(def-exported-foreign-function (xsettile (:name "XSetTile"))
    (dpy pointer-struct-display)
  (gc gc)
  (tile pixmap))

(def-exported-foreign-function (xstorecolor (:name "XStoreColor"))
    (dpy pointer-struct-display)
  (cmap colormap)
  (def (:pointer xcolor)))

(def-exported-foreign-function (xstorecolors (:name "XStoreColors"))
    (dpy pointer-struct-display)
  (cmap colormap)
  (defs (:pointer xcolor))
  (ncolors int))

(def-exported-foreign-function (xstorenamedcolor (:name "XStoreNamedColor"))
    (dpy pointer-struct-display)
  (cmap colormap)
  (name (:pointer char))
  (pixel unsigned-long)
  (flags int))

(def-exported-foreign-function (xstorename (:name "XStoreName"))
    (dpy pointer-struct-display)
  (w window)
  (name (:pointer char)))

(def-exported-foreign-function (xseticonname (:name "XSetIconName"))
    (dpy pointer-struct-display)
  (w window)
  (icon-name (:pointer char)))

(def-exported-foreign-function (xstringtokeysym (:return-type keysym) (:name "XStringToKeysym"))
    (s (:pointer char)))

(def-exported-foreign-function (xkeysymtostring (:return-type (:pointer char)) (:name "XKeysymToString"))
    (ks keysym))

(def-exported-foreign-function (xsync (:name "XSync"))
    (dpy pointer-struct-display)
  (discard int))

(def-exported-foreign-function (xsynchronize (:return-type (:pointer :pointer)) (:name "XSynchronize"))
    (dpy pointer-struct-display)
  (onoff int))

(def-exported-foreign-function (xsetafterfunction (:return-type (:pointer :pointer)) (:name "XSetAfterFunction"))
    (dpy pointer-struct-display)
  (func (:pointer :pointer)))

(def-exported-foreign-function (xtextextents (:name "XTextExtents"))
    (fontstruct (:pointer xfontstruct))
  (string (:pointer char))
  (nchars int)
  (dir (:pointer int))
  (font-ascent (:pointer int))
  (font-descent (:pointer int))
  (overall (:pointer xcharstruct)))

(def-exported-foreign-function (xtextwidth (:return-type int) (:name "XTextWidth"))
    (fontstruct (:pointer xfontstruct))
  (string (:pointer char))
  (count int))

(def-exported-foreign-function (xtextextents16 (:name "XTextExtents16"))
    (fontstruct (:pointer xfontstruct))
  (string (:pointer xchar2b))
  (nchars int)
  (dir (:pointer int))
  (font-ascent (:pointer int))
  (font-descent (:pointer int))
  (overall (:pointer xcharstruct)))

(def-exported-foreign-function (xtextwidth16 (:return-type int) (:name "XTextWidth16"))
    (fontstruct (:pointer xfontstruct))
  (string (:pointer xchar2b))
  (count int))

(def-exported-foreign-function (xtranslatecoordinates (:return-type int) (:name "XTranslateCoordinates"))
    (dpy pointer-struct-display)
  (src-win window)
  (dest-win window)
  (src-x int)
  (src-y int)
  (dst-x (:pointer int))
  (dst-y (:pointer int))
  (child (:pointer window)))

(def-exported-foreign-function (xundefinecursor (:name "XUndefineCursor"))
    (dpy pointer-struct-display)
  (w window))

(def-exported-foreign-function (xungrabbutton (:name "XUngrabButton"))
    (dpy pointer-struct-display)
  (button unsigned-int)
  (modifiers unsigned-int)
  (grab-window window))

(def-exported-foreign-function (xungrabkeyboard (:name "XUngrabKeyboard"))
    (dpy pointer-struct-display)
  (time :unsigned-32bit))

(def-exported-foreign-function (xungrabkey (:name "XUngrabKey"))
    (dpy pointer-struct-display)
  (key int)
  (modifiers unsigned-int)
  (grab-window window))

(def-exported-foreign-function (xungrabpointer (:name "XUngrabPointer"))
    (dpy pointer-struct-display)
  (time :unsigned-32bit))

(def-exported-foreign-function (xungrabserver (:name "XUngrabServer"))
    (dpy pointer-struct-display))

(def-exported-foreign-function (xuninstallcolormap (:name "XUninstallColormap"))
    (dpy pointer-struct-display)
  (cmap colormap))

(def-exported-foreign-function (xunloadfont (:name "XUnloadFont"))
    (dpy pointer-struct-display)
  (font font))

(def-exported-foreign-function (xunmapsubwindows (:name "XUnmapSubwindows"))
    (dpy pointer-struct-display)
  (win window))

(def-exported-foreign-function (xunmapwindow (:name "XUnmapWindow"))
    (dpy pointer-struct-display)
  (w window))

(def-exported-foreign-function (xwarppointer (:name "XWarpPointer"))
    (dpy pointer-struct-display)
  (src-win window)
  (dest-win window)
  (src-x int)
  (src-y int)
  (src-width unsigned-int)
  (src-height unsigned-int)
  (dest-x int)
  (dest-y int))

(def-exported-foreign-function (xwindowevent (:name "XWindowEvent"))
    (dpy pointer-struct-display)
  (w window)
  (mask long)
  (event (:pointer xevent)))

(def-exported-foreign-function (xcreatewindow (:return-type window) (:name "XCreateWindow"))
    (dpy pointer-struct-display)
  (parent window)
  (x int)
  (y int)
  (width unsigned-int)
  (height unsigned-int)
  (borderwidth unsigned-int)
  (depth int)
  (class unsigned-int)
  (visual (:pointer visual))
  (valuemask unsigned-long)
  (attributes (:pointer xsetwindowattributes)))

(def-exported-foreign-function (xfree (:name "XFree"))
    (data (:pointer char)))

(def-exported-foreign-function (system-malloc
				(:return-type (:pointer char))
				(:name "malloc"))
    (size int))


(def-exported-foreign-function (xcreateimage (:return-type (:pointer ximage))
					     (:name "XCreateImage"))
    (dpy pointer-struct-display)
  (visual (:pointer visual))
  (depth unsigned-int)
  (format int)
  (offset int)
  (data  (:pointer char))
  (width unsigned-int)
  (height unsigned-int)
  (bitmap-pad int)
  (bytes-per-line int))

(def-exported-foreign-macro (xdestroyimage (:return-type int) (:name "XDestroyImage"))
    (ximage (:pointer ximage)))

(def-exported-foreign-macro (xgetpixel (:return-type unsigned-long) (:name "XGetPixel"))
    (ximage (:pointer ximage))
  (x int)
  (y int))

(def-exported-foreign-macro (xputpixel (:return-type int) (:name "XPutPixel"))
    (ximage (:pointer ximage))
  (x int)
  (y int)
  (pixel unsigned-long))

(def-exported-foreign-macro (xsubimage (:return-type (:pointer ximage)) (:name "XSubImage"))
    (ximage (:pointer ximage))
  (x int)
  (y int)
  (subimage-width unsigned-int)
  (subimage-height unsigned-int))

(def-exported-foreign-macro (xaddpixel (:name "XAddPixel"))
    (ximage (:pointer ximage))
  (value long))

(def-exported-foreign-function (xreadbitmapfile (:return-type int) (:name "XReadBitmapFile"))
    (display pointer-struct-display)
  (d drawable)
  (filename (:pointer char))
  (width_return (:pointer unsigned-int))
  (height_return (:pointer unsigned-int))
  (bitmap_return (:pointer pixmap))
  (x-hot-return (:pointer int))
  (y-hot-return (:pointer int)))

(def-exported-foreign-function (xwritebitmapfile (:return-type int) (:name "XWriteBitmapFile"))
    (display pointer-struct-display)
  (filename (:pointer char))
  (bitmap pixmap)
  (width unsigned-int)
  (height unsigned-int)
  (x-hot int)
  (y-hot int))



;;; Xlib Output Functions
;;;
;;; All of the following functions have been modified - the type of int coordinate
;;; arguments have been changed to fixnum-int, the type of drawable arguments
;;; have been changed to fixnum-drawable, the type of int and unsigned-int dimensions
;;; (length, npoints etc) arguments have been changed to fixnum-int or fixnum-unsigned-int,
;;; and the :return-type option has been omitted (to avoid consing up an integer
;;; return value).  A function that draws a single character, XDrawChar function has
;;; been added.

(def-exported-foreign-function (xdrawarc (:name "XDrawArc"))
    (dpy pointer-struct-display)
  (d fixnum-drawable)
  (gc gc)
  (x fixnum-int)
  (y fixnum-int)
  (width fixnum-int)
  (height fixnum-int)
  (angle1 fixnum-int)
  (angle2 fixnum-int))

(def-exported-foreign-function (xdrawarcs (:name "XDrawArcs"))
    (dpy pointer-struct-display)
  (d fixnum-drawable)
  (gc gc)
  (arcs (:pointer xarc))
  (n-arcs fixnum-int))

(def-exported-foreign-function (xdrawline (:name "XDrawLine"))
    (dpy pointer-struct-display)
  (d fixnum-drawable)
  (gc gc)
  (x1 fixnum-int)
  (y1 fixnum-int)
  (x2 fixnum-int)
  (y2 fixnum-int))

(def-exported-foreign-function (xdrawlines (:name "XDrawLines"))
    (dpy pointer-struct-display)
  (d fixnum-drawable)
  (gc gc)
  (points (:pointer xpoint))
  (npoints fixnum-int)
  (mode fixnum-int))

(def-exported-foreign-function (xdrawpoint (:name "XDrawPoint"))
    (dpy pointer-struct-display)
  (d fixnum-drawable)
  (gc gc)
  (x fixnum-int)
  (y fixnum-int))

(def-exported-foreign-function (xdrawpoints (:name "XDrawPoints"))
    (dpy pointer-struct-display)
  (d fixnum-drawable)
  (gc gc)
  (points (:pointer xpoint))
  (n-points fixnum-int)
  (mode fixnum-int))

(def-exported-foreign-function (xdrawrectangle (:name "XDrawRectangle"))
    (dpy pointer-struct-display)
  (d fixnum-drawable)
  (gc gc)
  (x fixnum-int)
  (y fixnum-int)
  (width fixnum-unsigned-int)
  (height fixnum-unsigned-int))

(def-exported-foreign-function (xdrawrectangles (:name "XDrawRectangles"))
    (dpy pointer-struct-display)
  (d fixnum-drawable)
  (gc gc)
  (rects (:pointer xrectangle))
  (n-rects fixnum-int)) ;; was int

(def-exported-foreign-function (xdrawsegments (:name "XDrawSegments"))
    (dpy pointer-struct-display)
  (d fixnum-drawable)
  (gc gc)
  (segments (:pointer xsegment))
  (nsegments fixnum-int))

(def-exported-foreign-function (xdrawimagestring (:name "XDrawImageString"))
    (dpy pointer-struct-display)
  (d fixnum-drawable)
  (gc gc)
  (x fixnum-int)
  (y fixnum-int)
  (string (:pointer char))
  (length fixnum-int))

(def-exported-foreign-function (xdrawimagestring16 (:name "XDrawImageString16"))
    (dpy pointer-struct-display)
  (d fixnum-drawable)
  (gc gc)
  (x fixnum-int)
  (y fixnum-int)
  (string (:pointer xchar2b))
  (length fixnum-int))

(def-exported-foreign-function (xdrawtext (:name "XDrawText"))
    (dpy pointer-struct-display)
  (d fixnum-drawable)
  (gc gc)
  (x fixnum-int)
  (y fixnum-int)
  (items (:pointer xtextitem))
  (nitems fixnum-int))

(def-exported-foreign-function (xdrawtext16 (:name "XDrawText16"))
    (dpy pointer-struct-display)
  (d fixnum-drawable)
  (gc gc)
  (x fixnum-int)
  (y fixnum-int)
  (items (:pointer xtextitem16))
  (nitems fixnum-int))

(def-exported-foreign-function (xdrawstring (:name "XDrawString"))
    (dpy pointer-struct-display)
  (d fixnum-drawable)
  (gc gc)
  (x fixnum-int)
  (y fixnum-int)
  (string (:pointer char))
  (length fixnum-int))

(def-exported-foreign-function (xmbdrawstring (:name "XmbDrawString"))
    (dpy pointer-struct-display)
  (d fixnum-drawable)
  (font-set xfontset)
  (gc gc)
  (x fixnum-int)
  (y fixnum-int)
  (string (:pointer char))
  (length fixnum-int))

(def-exported-foreign-function (xdrawstring16 (:name "XDrawString16"))
    (dpy pointer-struct-display)
  (d fixnum-drawable)
  (gc gc)
  (x fixnum-int)
  (y fixnum-int)
  (string (:pointer xchar2b))
  (length fixnum-int))

;; (def-exported-foreign-function (XDrawChar (:name "XDrawString"))
;;    (dpy pointer-struct-display)
;;    (d fixnum-drawable)
;;    (gc gc)
;;    (x fixnum-int)
;;    (y fixnum-int)
;;    (string x11-char-string)
;;    (length fixnum-int))


(def-exported-foreign-function (lisp-xdrawstring (:name "lisp_XDrawString"))
    (dpy pointer-struct-display)
  (d fixnum-drawable)
  (gc gc)
  (x fixnum-int)
  (y fixnum-int)
  (string (:pointer char))
  (start fixnum-int)
  (end fixnum-int))

(def-exported-foreign-function (lisp-xdrawstring16 (:name "lisp_XDrawString16"))
    (dpy pointer-struct-display)
  (d fixnum-drawable)
  (gc gc)
  (x fixnum-int)
  (y fixnum-int)
  (string (:pointer xchar2b))
  (start fixnum-int)
  (end fixnum-int))

(def-exported-foreign-function
    (xpermalloc (:return-type (:pointer char))
		(:name "Xpermalloc"))
    (size unsigned-int))

(def-exported-foreign-function
    (xrmstringtoquark (:return-type xrmquark)
                      (:name "XrmStringToQuark"))
    (name xrmstring))

(def-exported-foreign-function
    (xrmquarktostring (:return-type xrmstring)
                      (:name "XrmQuarkToString"))
    (name xrmquark))

(def-exported-foreign-function
    (xrmuniquequark (:return-type xrmquark)
                    (:name "XrmUniqueQuark")))

(def-exported-foreign-function
    (xrmstringtoquarklist (:return-type void)
                          (:name "XrmStringToQuarkList"))
    (name (:pointer char))
  (quarks xrmquarklist))

(def-exported-foreign-function
    (xrmstringtobindingquarklist (:return-type void)
				 (:name "XrmStringToBindingQuarkList"))
    (name (:pointer char))
  (bindings xrmbindinglist)
  (quarks xrmquarklist))

(def-exported-foreign-function
    (xrminitialize (:return-type void)
                   (:name "XrmInitialize")))

(def-exported-foreign-function
    (xrmqputresource (:return-type void)
                     (:name "XrmQPutResource"))
    (pdb (:pointer xrmdatabase))
  (bindings xrmbindinglist)
  (quarks xrmquarklist)
  (type xrmrepresentation)
  (value (:pointer xrmvalue)))

(def-exported-foreign-function
    (xrmputresource (:return-type void)
                    (:name "XrmPutResource"))
    (pdb (:pointer xrmdatabase))
  (specifier (:pointer char))
  (type (:pointer char))
  (value (:pointer xrmvalue)))

(def-exported-foreign-function
    (xrmqputstringresource (:return-type void)
                           (:name "XrmQPutStringResource"))
    (pdb (:pointer xrmdatabase))
  (bindings xrmbindinglist)
  (quarks xrmquarklist)
  (str (:pointer char)))

(def-exported-foreign-function
    (xrmputstringresource (:return-type void)
                          (:name "XrmPutStringResource"))
    (pdb (:pointer xrmdatabase))
  (specifier (:pointer char))
  (str (:pointer char)))

(def-exported-foreign-function
    (xrmputlineresource (:return-type void)
			(:name "XrmPutLineResource"))
    (pdb (:pointer xrmdatabase))
  (line (:pointer char)))

(def-exported-foreign-function
    (xrmqgetresource (:return-type int)
                     (:name "XrmQGetResource"))
    (db xrmdatabase)
  (names xrmnamelist)
  (classes xrmclasslist)
  (type (:pointer xrmrepresentation))
  (value (:pointer xrmvalue)))

(def-exported-foreign-function
    (xrmgetresource (:return-type :fixnum)
                    (:name "XrmGetResource"))
    (db xrmdatabase)
  (name-str (:pointer char))
  (class-str (:pointer char))
  (type (:pointer (:pointer char)))
  (value (:pointer xrmvalue)))

(def-exported-foreign-function
    (xrmqgetsearchlist (:return-type :fixnum)
                       (:name "XrmQGetSearchList"))
    (db xrmdatabase)
  (names xrmnamelist)
  (classes xrmclasslist)
  (searchlist xrmsearchlist)
  (listlength int))

(def-exported-foreign-function
    (xrmqgetsearchresource (:return-type :fixnum)
                           (:name "XrmQGetSearchResource"))
    (searchlist xrmsearchlist)
  (name xrmname)
  (class xrmclass)
  (type (:pointer xrmrepresentation))
  (value (:pointer xrmvalue)))

(def-exported-foreign-function
    (xrmgetfiledatabase (:return-type xrmdatabase)
			(:name "XrmGetFileDatabase"))
    (filename (:pointer char)))

(def-exported-foreign-function
    (xrmgetstringdatabase (:return-type xrmdatabase)
                          (:name "XrmGetStringDatabase"))
    (data (:pointer char)))

(def-exported-foreign-function
    (xrmputfiledatabase (:return-type void)
			(:name "XrmPutFileDatabase"))
    (db xrmdatabase)
  (filename (:pointer char)))

(def-exported-foreign-function
    (xrmmergedatabases (:return-type void)
                       (:name "XrmMergeDatabases"))
    (new xrmdatabase)
  (into (:pointer xrmdatabase)))

(def-exported-foreign-function
    (xrmparsecommand (:return-type void)
                     (:name "XrmParseCommand"))
    (pdb (:pointer xrmdatabase))
  (options xrmoptiondesclist)
  (num-options int)
  (prefix (:pointer char))
  (argc (:pointer int))
  (argv (:pointer (:pointer char))))

(def-exported-foreign-function (xallocwmhints
				(:name "XAllocWMHints")
				(:return-type (:pointer xwmhints))))

(def-exported-foreign-function (xsetwmhints (:name "XSetWMHints"))
    (display pointer-struct-display)
  (window window)
  (wmhints (:pointer xwmhints)))

(def-exported-foreign-function (xgetwmhints (:return-type (:pointer xwmhints))
					    (:name "XGetWMHints"))
    (display pointer-struct-display)
  (window window))

(def-exported-foreign-function (xallocsizehints
				(:name "XAllocSizeHints")
				(:return-type (:pointer xsizehints))))

(def-exported-foreign-function (xsetwmnormalhints (:return-type void)
						  (:name "XSetWMNormalHints"))
    (display pointer-struct-display)
  (window window)
  (sizehints (:pointer xsizehints)))

(def-exported-foreign-function (xgetwmnormalhints (:return-type int)
						  (:name "XGetWMNormalHints"))
    (display pointer-struct-display)
  (window window)
  (hints-return (:pointer xsizehints))
  (supplied-return (:pointer long)))


(def-exported-foreign-function (xsavecontext (:return-type fixnum-int)
					     (:name "XSaveContext"))
    (window window)
  (context xcontext)
  (data (:pointer :signed-32bit)))

(def-exported-foreign-function (xfindcontext (:return-type fixnum-int)
					     (:name "XFindContext"))
    (display pointer-struct-display)
  (window window)
  (context xcontext)
  (data (:pointer :signed-32bit)))

(def-exported-foreign-function (xdeletecontext (:return-type fixnum-int)
					       (:name "XDeleteContext"))
    (window window)
  (context xcontext))

(def-exported-foreign-function (xfilterevent (:return-type fixnum-int)
                                             (:name "XFilterEvent"))
    (event (:pointer xevent))
  (window window))

(def-exported-foreign-function (xlookupstring (:return-type fixnum-int)
					      (:name "XLookupString"))
    (event-struct  (:pointer xkeyevent))
  (buffer-return (:pointer char))
  (bytes-buffer	int)
  (keysym-return (:pointer keysym))
  (status-in-out (:pointer xcomposestatus)))

(def-exported-foreign-function (xiconifywindow (:name "XIconifyWindow"))
    (dpy pointer-struct-display)
  (win window)
  (scr int))

(def-exported-foreign-function (xmatchvisualinfo (:return-type int)
						 (:name "XMatchVisualInfo"))
    (dpy pointer-struct-display)
  (scr int)
  (depth int)
  (class int)
  (vinfo-return (:pointer visual-info)))

(def-exported-foreign-function (_xflushgccache (:name "_XFlushGCCache"))
    (dpy pointer-struct-display)
  (gc gc))

(def-exported-foreign-function (xopenim (:return-type xim) (:name "XOpenIM"))
    (dpy pointer-struct-display)
  (db xrmdatabase)
  (res-name (:pointer char))
  (res-class (:pointer char)))

(def-exported-foreign-function (xcreatefontset (:return-type xfontset) (:name "XCreateFontSet"))
    (dpy pointer-struct-display)
  (base-names (:pointer char))
  (missing-list (:pointer (:pointer (:pointer char))))
  (missing-count (:pointer int))
  (default-string (:pointer (:pointer char))))

(def-exported-foreign-function (xfontsoffontset (:return-type int) (:name "XFontsOfFontSet"))
    (font-set xfontset)
  (font-struct-list (:pointer (:pointer (:pointer xfontstruct))))
  (font-name-list (:pointer (:pointer (:pointer char)))))


(def-exported-foreign-function (xmbtextextents (:return-type int)
					       (:name "XmbTextExtents"))
    (font-set xfontset)
  (string (:pointer char))
  (num-bytes int)
  (overall-ink-return (:pointer xrectangle))
  (overall-logical-return (:pointer xrectangle)))

(def-exported-foreign-function (_xgetbitsperpixel (:return-type int)
						  (:name "_XGetBitsPerPixel"))
    (dpy pointer-struct-display)
  (depth int))

(def-exported-foreign-function (xmbtextescapement (:return-type int)
                                                  (:name "XmbTextEscapement"))
    (font-set xfontset)
  (string (:pointer char))
  (num-bytes int))
