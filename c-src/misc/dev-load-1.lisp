;; -*- mode: common-lisp; package: user -*-
;;
;;
;; See the file LICENSE for the full license governing this code.
;;

;;;; This should not matter
;;;; (setq *ignore-package-name-case* t)

;; Forgive them, lord, for they know not what they do.
(pushnew :ansi-90 *features*)

(tenuring
 (let ((*load-source-file-info* t)
       (*record-source-file-info* t)
       (*load-xref-info* nil))
   (load "clim2:;sys;sysdcl")))
