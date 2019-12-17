

(let ((name 'command-menu-element)
      (parameters '()))
  (with-warnings-for-definition name define-presentation-type
    (let* ((parameters-var '#:parameters)
           (options-var '#:options)
           (type-var '#:type)
           (function-var '#:function)
           (parameters-ll (asterisk-default parameters))
           (options-ll (lambda-list-from-options options))
           (class (if (symbolp name) (find-class-that-works name nil environment) name))
           (direct-superclasses (and class
                                     (mapcar #'(lambda (class)
                                                 (class-proper-name class environment))
                                             (class-direct-superclasses class))))
           ;; Default the supertype if unsupplied or nil
           ;; This assumes consistency of the compile-time and load-time environments.  Okay?
           (inherit-from (cond (inherit-from)
                               ((null class) `'standard-object)
                               ((cdr direct-superclasses) `'(and ,@direct-superclasses))
                               (t `',(first direct-superclasses)))))

      ;; Default the :description option
      (unless description
        (setq description (substitute #\space #\- (string-downcase
                                                   (if (symbolp name) name
                                                       (class-name name))))))

      ;; Convert :inherit-from into what we need to inherit methods and map over supertypes
      (multiple-value-bind (direct-supertypes parameter-massagers options-massagers)
          (analyze-inherit-from inherit-from parameters-ll options-ll)

        ;; Make sure we have a class adequate to use at macro expansion time.
        ;; It has to have the right clos:class-precedence-list, as well as serving
        ;; as a key for the second position of *presentation-type-being-defined*.
        ;; If not compiling to a file, it has to be EQ to the class that will
        ;; be used for real when methods are invoked.  If compiling to a file, it
        ;; has to be similar as a constant to the class that will be used for real.
        ;;--- Might have to think this through a bit better
        ;;--- In particular, merely macroexpanding should not define the p.t. class
        ;;--- if it was not already defined, and also it's undesirable to change the
        ;;--- direct supertypes during macroexpansion, although we have to do that
        ;;--- to get the CPL right.  Maybe the CPL has to be specially kludged somehow
        ;;--- in *presentation-type-being-defined* ???
        (unless (acceptable-presentation-type-class class)
          (setq class (ensure-presentation-type name parameters options direct-supertypes
                                                description history
                                                parameters-are-types
                                                parameter-massagers options-massagers
                                                environment)))

        ;; Establish the information needed at macro expansion time
        (let ((*presentation-type-being-defined*
               (list name class parameters options
                     direct-supertypes parameter-massagers options-massagers)))

          ;; Generate the form that stores all the information and defines the
          ;; automatically-defined presentation methods
          `(progn
             (eval-when (compile)
               (ensure-presentation-type ',name ',parameters ',options ',direct-supertypes
                                         ',description ',history
                                         ',parameters-are-types
                                         ',parameter-massagers ',options-massagers
                                         ;; Can't just put the environment here, since macro
                                         ;; expansion environments have dynamic extent
                                         ',(and (compile-file-environment-p environment)
						#-(and allegro (version>= 7 0)) 'compile-file
						#+(and allegro (version>= 7 0))
						(sys:augment-environment environment))))
             (define-group ,name define-presentation-type
               (ensure-presentation-type ',name ',parameters ',options ',direct-supertypes
                                         ',description ',history
                                         ',parameters-are-types
                                         ',parameter-massagers ',options-massagers)
               ,@(unless omit-map-over-ptype-supertypes-p
                   (generate-map-over-presentation-type-supertypes-method-if-needed
                    name class function-var parameters-var options-var type-var environment))
               #-CLIM-extends-CLOS
               ,@(generate-presentation-type-inheritance-methods
                  name class parameters-var options-var environment)
               ',name)))))))
