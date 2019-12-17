

(defmethod find-all-subclasses ((class symbol))
  (find-all-subclasses (find-class class)))

(defmethod find-all-subclasses ((class class))
  (let ((direct-subclasses
	 (closer-mop:class-direct-subclasses class)))
    (if (= (length direct-subclasses) 0)
	(class-name class)
	(list (class-name class)
	      (mapcar
	       #'find-all-subclasses
	       direct-subclasses)))))

(defmethod find-all-superclasses ((class symbol))
  (find-all-superclasses (find-class class)))

(defmethod find-all-superclasses ((class class))
  (let ((direct-subclasses
	 (closer-mop:class-direct-subclasses class)))
    (if (= (length direct-subclasses) 0)
	(class-name class)
	(list (class-name class)
	      (mapcar
	       #'find-all-subclasses
	       direct-subclasses)))))



(defmethod meta-find-all ((object symbol) (object-type (eql :superclass)))
  (meta-find-all (find-class 'symbol) object-type))

(defmethod meta-find-all ((object standard-class) (object-type (eql :superclass)))
  (meta-find-all (find-class 'symbol) object-type))

(defmethod meta-find-all ((object symbol) (object-type (eql :superclass)))

  (defmethod meta-find-all (object (object-type (eql :subclass)))

    (defmethod meta-find-all (object (object-type (eql :slot)))



(closer-mop::class-direct-superclasses

(defmethod find-all-subclasses ((class symbol))
  (find-all-slots (find-class class)))

(defmethod find-all-slots ((class class))
  (let ((direct-slots
	 (closer-mop:class-direct-subclasses class))
	(direct-super-classes ()
    (if (= (length direct-subclasses) 0)
	(class-name class)
	(list (class-name class)
	      (mapcar
	       #'find-all-subclasses
	       direct-subclasses)))))




(1 (find-all-subclasses (find-class class)))


;; (closer-mop:class-direct-subclasses
;;  (find-class 'cffi::foreign-type))
