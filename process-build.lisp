
(defparameter *output-string*
  (make-array '(0) :element-type 'base-char
	      :fill-pointer 0 :adjustable t))


(defparameter *output-string*
  (asdf::run-program '("ls" "/") :output :string))

(defparameter *output-stream-string* nil)


(asdf::run-program `("cp" "-lax" "--parents"
               "src/foo" *output-string*))

(defun handle-run-program (input-stream)
  (with-output-to-string (stream *output-string*)
    (slurp-input-stream stream input-stream)))


    ;; (slurp-input-stream processor input-stream))
