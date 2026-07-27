#
# Makefile for dump978-rb
#

PRJ := dump978-rb


VERSION ?= $(shell git rev-parse --short HEAD)

ifneq ($(VERSION),)
	CPPFLAGS += -DVERSION=\"$(VERSION)\"
endif

CC ?= gcc
CXX ?= g++

OPTLVL ?= 2
DBGLVL ?= 0
CSTD   ?= gnu11
CXXSTD ?= gnu++14

CFLAGS += -Wall -Werror -std=$(CSTD) -O$(OPTLVL) -g$(DBGLVL) -Ilibs
CXXFLAGS += -Wall -Wno-psabi -Werror -std=$(CXXSTD) -O$(OPTLVL) -g$(DBGLVL) -Ilibs

LIBS := -lboost_system \
		-lboost_program_options \
		-lboost_regex \
		-lboost_filesystem \
		-lpthread
LIBS_SDR := -lSoapySDR


OBJS := dump978_main.o \
		socket_output.o \
		message_dispatch.o \
		fec.o \
		libs/fec/init_rs_char.o \
		libs/fec/decode_rs_char.o \
		sample_source.o \
		soapy_source.o \
		convert.o \
		demodulator.o \
		uat_message.o \
		stratux_serial.o

OBJS_FEC_TESTS := fec_tests.o \
		libs/fec/init_rs_char.o \
		libs/fec/decode_rs_char.o \
		libs/fec/encode_rs_char.o


all: $(PRJ)

$(PRJ): $(OBJS)
	$(CXX) $(CXXFLAGS) $(LDFLAGS) $^ -o $@ $(LIBS) $(LIBS_SDR)

fec_tests: $(OBJS_FEC_TESTS)
	$(CXX) $(CXXFLAGS) $(LDFLAGS) $^ -o $@

format:
	clang-format -style=file -i *.cc *.h

clean:
	rm -f *.o libs/fec/*.o $(PRJ) fec_tests
