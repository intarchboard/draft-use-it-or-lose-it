include lib/main.mk

lib/main.mk:
ifneq (,$(shell git submodule status lib 2>/dev/null))
	git submodule sync
	git submodule update --init
else
	git clone -q --depth 10 -b master https://github.com/martinthomson/i-d-template.git lib
endif

ifneq (,$(CIRCLE_TEST_REPORTS))
TEST_REPORT := $(CIRCLE_TEST_REPORTS)/report/drafts.xml
else
TEST_REPORT := report.xml
endif
.PHONY: report
report: $(TEST_REPORT)

$(TEST_REPORT): $(dir $(TEST_REPORT))
$(dir $(TEST_REPORT)):
	mkdir -p $@

$(TEST_REPORT): $(drafts_html) $(drafts_txt)
	@echo build_report $^
	@echo '<?xml version="1.0" encoding="UTF-8"?>' >$@
	@passed=();failed=();for i in $^; do \
	  if [ -f "$$i" ]; then passed+=("$$i"); else failed+=("$$i"); fi; \
	done; echo '<testsuite' >>$@; \
	echo '    tests="'"$$(($${#passed[@]} + $${#failed[@]}))"'"' >>$@; \
	echo '    failures="'"$${#failed[@]}"'">' >>$@; \
	for i in "$${passed[@]}"; do \
	  echo '  <testcase name="'"$$i"'" classname="build.'"$${i%.*}"'"/>' >>$@; \
	done; \
	for i in "$${failed[@]}"; do \
	  echo '  <testcase name="'"$$i"'" classname="build.'"$${i%.*}"'">' >>$@; \
	  echo '    <failure message="Error building file"/>' >>$@; \
	  echo '  </testcase>' >>$@; \
	done; \
	echo '</testsuite>' >>$@
