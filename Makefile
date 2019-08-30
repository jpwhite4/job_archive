SOURCES = job_archive.cpp

CXXFLAGS = -W -Wall -Werror
LDFLAGS = -lpthread -pthread

# If using gcc >= 4.8.1
CXXFLAGS+=-std=c++11
# If using gcc in Centos 6
# CXXFLAGS+=-std=c++0x

OBJECTS = $(SOURCES:.cpp=.o)

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
