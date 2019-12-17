;; From:
;; (macroexpand
;;  '(FF-WRAPPER:DEF-C-TYPE
;;    *-ARRAY
;;    1
;;    *))
;;
;; #.(SB-SYS:INT-SAP #X7F1248005EC0)
;;
;; ((SETF TK::*-ARRAY) #.(SB-SYS:INT-SAP #X7F12480129B0) #.(SB-SYS:INT-SAP #X7F1248005EC0) 0)
;;
;; (*-array #.(SB-SYS:INT-SAP #X7F1248005EC0) 0)
(EVAL-WHEN (EVAL LOAD COMPILE)
  (PROGN
   (DEFUN MAKE-*-ARRAY
          (&KEY NUMBER FF-WRAPPER::IN-FOREIGN-SPACE FF-WRAPPER::INITIALIZE)
     (DECLARE (IGNORE FF-WRAPPER::IN-FOREIGN-SPACE FF-WRAPPER::INITIALIZE))
     (CFFI:FOREIGN-ALLOC :POINTER :COUNT NUMBER))
   (DEFUN *-ARRAY (FF-WRAPPER::ENTRY-POINT FF-WRAPPER::INDEX)
     (CFFI:MEM-AREF FF-WRAPPER::ENTRY-POINT :POINTER FF-WRAPPER::INDEX))
   (DEFUN (SETF *-ARRAY)
          (FF-WRAPPER::ENTRY-POINT FF-WRAPPER::INDEX FF-WRAPPER::VALUE)
     (SETF (CFFI:MEM-AREF FF-WRAPPER::ENTRY-POINT :POINTER FF-WRAPPER::INDEX)
             FF-WRAPPER::VALUE))))

(CFFI:DEFCFUN (ALISP_XT_APP_SET_FALLBACK_RESOURCES
                  "XtAppSetFallbackResources")
       :VOID
     (X :POINTER)
     (Y :POINTER))
