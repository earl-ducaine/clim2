
generate_test_report: FORCE
	($(ECHO) " \
	(clim-test::generate-pretty-test-report :file \"$(REPORT_FILE)\")" \
	| $(LISP) -I $(CLIM) $(CLOPTS))



profile: FORCE
	($(ECHO) " \
	(clim-user::run-profile-clim-tests)" \
	| $(LISP) -I $(CLIM) $(CLOPTS))

benchmark: FORCE
	($(ECHO) " \
	(clim-test::benchmark-clim nil)" \
	| $(LISP) -I $(CLIM) $(CLOPTS))

testps: FORCE
	($(ECHO) " \
	(load \"test/postscript-tests.lisp\") \
	(clim-user::run-postscript-tests :output $(PSVIEW))" \
	| $(LISP) -I $(CLIM) $(CLOPTS))
