#
ROOT=db
DBSTRU=stbs2.stru
PWD      := $(shell pwd)
.PHONY: table
read.me:
	@echo "Формат вызова"
	@echo "make all"
#all: stru language extension schema server mapuser type domain sequence table view function trigger diff
all: stru language extension schema server type domain sequence table view function trigger diff
stru: 
#	pg_dump stbs2 -c -s -h s08 -U ${HOME##*/}>$(DBSTRU)
	pg_dump stbs2 -c -s -h s08 >$(DBSTRU)
table:
	if [ -d "$(ROOT)/$@" ]; then rm -fr $(ROOT)/$@; fi
	mkdir -p $(ROOT)/$@
	./parser_.pl $(ROOT)/$@ $(DBSTRU) $@
	./parser_.pl $(ROOT)/$@ $(DBSTRU) $@_column
	./parser_.pl $(ROOT)/$@ $(DBSTRU) $@_constraint
	./parser_.pl $(ROOT)/$@ $(DBSTRU) $@_index
	./parser_.pl $(ROOT)/$@ $(DBSTRU) $@_grant
	./parser_.pl $(ROOT)/$@ $(DBSTRU) $@_comment
trigger:
	if [ -d "$(ROOT)/$@" ]; then rm -fr $(ROOT)/$@; fi
	mkdir -p $(ROOT)/$@
	./parser_.pl $(ROOT)/$@ $(DBSTRU) $@
view:
	if [ -d "$(ROOT)/$@" ]; then rm -fr $(ROOT)/$@; fi
	mkdir -p $(ROOT)/$@
	./parser_.pl $(ROOT)/$@ $(DBSTRU) $@
function:
	if [ -d "$(ROOT)/$@" ]; then rm -fr $(ROOT)/$@; fi
	mkdir -p $(ROOT)/$@
	./parser_.pl $(ROOT)/$@ $(DBSTRU) $@
sequence:
	if [ -d "$(ROOT)/$@" ]; then rm -fr $(ROOT)/$@; fi
	mkdir -p $(ROOT)/$@
	./parser_.pl $(ROOT)/$@ $(DBSTRU) $@
	./parser_.pl $(ROOT)/$@ $(DBSTRU) $@_grant
	
schema:
	if [ -d "$(ROOT)/$@" ]; then rm -fr $(ROOT)/$@; fi
	mkdir -p $(ROOT)/$@
	./parser_.pl $(ROOT)/$@ $(DBSTRU) $@
domain:
	if [ -d "$(ROOT)/$@" ]; then rm -fr $(ROOT)/$@; fi
	mkdir -p $(ROOT)/$@
	./parser_.pl $(ROOT)/$@ $(DBSTRU) $@
type:
	if [ -d "$(ROOT)/$@" ]; then rm -fr $(ROOT)/$@; fi
	mkdir -p $(ROOT)/$@
	./parser_.pl $(ROOT)/$@ $(DBSTRU) $@
extension:
	if [ -d "$(ROOT)/$@" ]; then rm -fr $(ROOT)/$@; fi
	mkdir -p $(ROOT)/$@
	./parser_.pl $(ROOT)/$@ $(DBSTRU) $@
language:
	if [ -d "$(ROOT)/$@" ]; then rm -fr $(ROOT)/$@; fi
	mkdir -p $(ROOT)/$@
	./parser_.pl $(ROOT)/$@ $(DBSTRU) $@
server:
	if [ -d "$(ROOT)/$@" ]; then rm -fr $(ROOT)/$@; fi
	mkdir -p $(ROOT)/$@
	./parser_.pl $(ROOT)/$@ $(DBSTRU) $@
	./parser_.pl $(ROOT)/$@ $(DBSTRU) $@_mapuser
diff:
	@echo "Сравнение последнего коммита и $(WEBROOT)"
	git --work-tree=$(PWD) status|grep -v -f $(PWD)/exclude_diff
#	git --work-tree=$(PWD) status|grep -v parser_dump/|grep -v parser_|egrep -v "#\s+(Makefile|READ.ME|stbs2.stru)"
    
