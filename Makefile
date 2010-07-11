ALL_TESTS = $(shell ls t/*.t)

default:
	@echo 'Try these `make` targets:'
	@echo
	@echo '    make test             # Run all tests'
	@echo '    make t/test.t         # Run a specific test'

test: $(ALL_TESTS)

$(ALL_TESTS): force
	PERL6LIB=t:lib perl6 $@

force:
