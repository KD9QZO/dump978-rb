#
# Makefile
#


VERSION ?= $(shell git rev-parse --short HEAD)

ifneq ($(VERSION),)
DEFINES += -DVERSION=\"$(VERSION)\"
endif


CC  ?= gcc
CXX ?= g++


CSTD := gnu11
CXXSTD := gnu++14
OPTLVL := 2
DBGLVL := 0


CFLAGS := -std=$(CSTD)
CFLAGS += -Wall -Werror
CFLAGS += -O$(OPTLVL) -g$(DBGLVL)
CFLAGS += $(DEFINES)
CFLAGS += -Ilibs

CXXFLAGS := -std=$(CXXSTD)
CXXFLAGS += -Wall -Wno-psabi -Werror
CXXFLAGS += -O$(OPTLVL) -g$(DBGLVL)
CXXFLAGS += $(DEFINES)
CXXFLAGS += -Ilibs

LDFLAGS :=


LIBS := -lboost_system -lboost_program_options -lboost_regex -lboost_filesystem -lpthread

LIBS_SDR := -lSoapySDR



all: dump978-rb


dump978-rb: dump978_main.o socket_output.o message_dispatch.o fec.o libs/fec/init_rs_char.o libs/fec/decode_rs_char.o sample_source.o soapy_source.o convert.o demodulator.o uat_message.o stratux_serial.o
	$(CXX) $(CXXFLAGS) $(LDFLAGS) $^ -o $@ $(LIBS) $(LIBS_SDR)

fec_tests: fec_tests.o libs/fec/init_rs_char.o libs/fec/decode_rs_char.o libs/fec/encode_rs_char.o
	$(CXX) $(CXXFLAGS) $(LDFLAGS) $^ -o $@

format:
	clang-format -style=file -i *.cc *.h

clean:
	rm -f *.o libs/fec/*.o dump978-rb fec_tests
