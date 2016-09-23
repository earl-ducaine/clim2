
(asdf:defsystem :clim2
    :depends-on (:clim2-pre-compile-0)
    :serial t
    :components
    ((:file "package")
     (:file "load-clim")
;;     (:file "cat")
     (:module demo
	      :depends-on (:package :load-clim)
	      :serial t
	      :components
	      (
	       (:file "packages")
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
     ))

(format t "~%to run demo: (clim-demo:start-demo)" nil)
