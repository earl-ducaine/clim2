




(defun create-package-network-diagram ()
  (mapcar
   (lambda (package)
     (let (symbols)
       (do-symbols (symbol package)
	 (push symbol symbols))
       (list package symbols)))
   (list-all-packages)))
