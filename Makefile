VERSION ?= 0.9.1
SOURCES = job_archive.cpp

CXXFLAGS = -W -Wall -Werror -pedantic -std=c++0x -ggdb
LDFLAGS = -lpthread -pthread

OBJECTS = $(SOURCES:.cpp=.o)

INIT_TYPE ?= sysvinit
BIN_DIR ?= /usr/local/bin
SYSTEMD_UNIT_DIR ?= /etc/systemd/system
SYSCONF_DIR ?= /etc/sysconfig
INITD_DIR ?= /etc/init.d

job_archive: $(OBJECTS)
	$(CXX) $(LDFLAGS) -o $@ $^

clean::
	$(RM) job_archive

.cpp.o:
	$(CXX) -MD -MP $(CXXFLAGS) -o $@ -c $<

clean::
	$(RM) *.o

DEPENDS = $(SOURCES:.cpp=.d)
-include $(DEPENDS)

%.d:
	@touch $@

clean::
	$(RM) *.d

.PHONY: install
install: job_archive
	install -D $^ $(BIN_DIR)/$^
	if [ "$(INIT_TYPE)" = "sysvinit" ]; then \
		install -D jobarchive-service-example $(INITD_DIR)/jobarchive; \
	else \
		install -m 644 -D dist/jobarchive.service $(SYSTEMD_UNIT_DIR)/jobarchive.service; \
		install -m 644 -D dist/jobarchive.conf $(SYSCONF_DIR)/jobarchive.conf; \
	fi

.PHONY: dist
dist:
	git archive --prefix=job_archive-$(VERSION)/ -o job_archive-$(VERSION).tar.gz HEAD
