;;; This file was written by Earl DuCaine.  It may be used in
;;; accordance with the licence specified in the LICENSE file or the
;;; MIT license.




(asdf:defsystem :clim2
    :depends-on (:clim2-pre-compile-0)
    :serial t
    :components
    ((:file "package")
     (:file "utils/packages")
     (:file "demo/packages")
     (:file "test/test-pkg")
     (:file "load-clim")

     ;;;(:file "test/test-pkg")
     (:file "test/test-driver")
     (:file "test/test-clim-tests")
     (:file "test/test-clim")
     (:file "test/test-demos")

     (:file "wnn/pkg")
     (:file "wnn/load-wnn")
     (:file "wnn/jl-defs")
     (:file "wnn/jl-funs")
     (:file "wnn/jserver")

     (:file "hpgl/pkg")
     (:file "hpgl/hpgl-port")
     (:file "hpgl/hpgl-medium")

     (:file "postscript/pkgdcl")
     (:file "postscript/postscript-s")
;;;     (:file "postscript/postscript-clim-stubs")
     (:file "postscript/postscript-port")
     (:file "postscript/postscript-medium")
     (:file "postscript/read-afm")
     (:file "postscript/laserwriter-metrics")
;;;     (:file "postscript/climps")

     (:module demo
	      :depends-on (:package :load-clim)
	      :serial t
	      :components
	      (
;;;	       (:file "packages")
	       (:file "demo-driver")
	       (:file "address-book")
	       (:file "bitmap-editor")
	       (:file "browser")
	       (:file "cad-demo")
	       (:file "cload-demos")
	       (:file "color-editor")
	       (:file "custom-records")
	       (:file "default-frame-top-level")
	       (:file "demo-activity")
	       (:file "demo-last")
	       (:file "graphics-demos")
	       (:file "graphics-editor")
	       (:file "ico")
	       (:file "japanese-graphics-editor")
	       (:file "listener")
	       (:file "navdata")
	       (:file "navfun")
	       (:file "palette")
	       (:file "peek-frame")
	       (:file "plot")
	       (:file "process-browser")
	       (:file "puzzle")
	       (:file "thinkadot")
	       ))
     (:file "clim-example" :depends-on (:demo))
     (:file "test/test-suite")
     ))

(format t "~%to run demo: (clim-demo:start-demo)" nil)
