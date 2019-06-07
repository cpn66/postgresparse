#
ROOT=db
DATABASE=stbs2
HOST=s11
DBSTRU=database.stru
PWD      := $(shell pwd)
.PHONY: table
read.me:
	@echo "Формат вызова"
	@echo "make all"
all: stru language extension schema server mapuser type domain sequence table view function trigger diff
stru: 
	pg_dump $(DATABASE) -h $(HOST) -c -s >$(DBSTRU)
table:
#	if [ -d "$(ROOT)/table" ]; then rm -fr $(ROOT)/table; fi
	if [ -d "$(ROOT)/$@" ]; then rm -fr $(ROOT)/$@; fi
	mkdir -p $(ROOT)/$@
	./parser_table.pl            $(ROOT)/$@ $(DBSTRU) 
	./parser_table_COLUMN.pl $(ROOT)/$@ $(DBSTRU) 
	./parser_table_CONSTRAINT.pl $(ROOT)/$@ $(DBSTRU) 
	./parser_table_INDEX.pl $(ROOT)/$@ $(DBSTRU) 
	./parser_table_GRANT.pl $(ROOT)/$@ $(DBSTRU) 
	./parser_table_COMMENT.pl $(ROOT)/$@ $(DBSTRU) 
trigger:
	if [ -d "$(ROOT)/$@" ]; then rm -fr $(ROOT)/$@; fi
	mkdir -p $(ROOT)/$@
	./parser_$@.pl            $(ROOT)/$@ $(DBSTRU) 
view:
	if [ -d "$(ROOT)/$@" ]; then rm -fr $(ROOT)/$@; fi
	mkdir -p $(ROOT)/$@
	./parser_$@.pl            $(ROOT)/$@ $(DBSTRU) 
function:
	if [ -d "$(ROOT)/$@" ]; then rm -fr $(ROOT)/$@; fi
	mkdir -p $(ROOT)/$@
	./parser_$@.pl            $(ROOT)/$@ $(DBSTRU) 
sequence:
	if [ -d "$(ROOT)/$@" ]; then rm -fr $(ROOT)/$@; fi
	mkdir -p $(ROOT)/$@
	./parser_$@.pl            $(ROOT)/$@ $(DBSTRU) 
	./parser_$@_GRANT.pl      $(ROOT)/$@ $(DBSTRU) 
	
schema:
	if [ -d "$(ROOT)/$@" ]; then rm -fr $(ROOT)/$@; fi
	mkdir -p $(ROOT)/$@
	./parser_$@.pl            $(ROOT)/$@ $(DBSTRU) 
domain:
	if [ -d "$(ROOT)/$@" ]; then rm -fr $(ROOT)/$@; fi
	mkdir -p $(ROOT)/$@
	./parser_$@.pl            $(ROOT)/$@ $(DBSTRU) 
type:
	if [ -d "$(ROOT)/$@" ]; then rm -fr $(ROOT)/$@; fi
	mkdir -p $(ROOT)/$@
	./parser_$@.pl            $(ROOT)/$@ $(DBSTRU) 
extension:
	if [ -d "$(ROOT)/$@" ]; then rm -fr $(ROOT)/$@; fi
	mkdir -p $(ROOT)/$@
	./parser_$@.pl            $(ROOT)/$@ $(DBSTRU) 
language:
	if [ -d "$(ROOT)/$@" ]; then rm -fr $(ROOT)/$@; fi
	mkdir -p $(ROOT)/$@
	./parser_$@.pl            $(ROOT)/$@ $(DBSTRU) 
server:
	if [ -d "$(ROOT)/$@" ]; then rm -fr $(ROOT)/$@; fi
	mkdir -p $(ROOT)/$@
	./parser_$@.pl            $(ROOT)/$@ $(DBSTRU) 
mapuser:
	if [ -d "$(ROOT)/$@" ]; then rm -fr $(ROOT)/$@; fi
	mkdir -p $(ROOT)/$@
	./parser_$@.pl            $(ROOT)/$@ $(DBSTRU) 
diff:
	@echo "Сравнение последнего коммита и $(WEBROOT)"
	git --work-tree=$(PWD) status|grep -v -f $(PWD)/exclude_diff
#	git --work-tree=$(PWD) status|grep -v parser_dump/|grep -v parser_|egrep -v "#\s+(Makefile|READ.ME|database.stru)"
    
