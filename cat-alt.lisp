(unless (ff-wrapper:get-entry-point
	 (ff-wrapper:convert-foreign-name "XmCreateMyDrawingArea"))
  (load "./liblib_motif_wrapper.so"))
