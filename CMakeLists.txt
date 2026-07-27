CMAKE_MINIMUM_REQUIRED(VERSION 3.5)
PROJECT(dump978-rb LANGUAGES C CXX)

#ADD_COMPILE_OPTIONS(-Ofast -march=native)

SET(SRC_FILES
		dump978_main.cc
		socket_output.cc
		message_dispatch.cc
		fec.cc
		libs/fec/init_rs_char.c
		libs/fec/decode_rs_char.c
		sample_source.cc
		soapy_source.cc
		convert.cc
		demodulator.cc
		uat_message.cc
		stratux_serial.cc
)

SET(LIBS
		pthread
		m
)


########################################################################################################################
#   ADD EXECUTABLE                                                                                                     #
########################################################################################################################

ADD_EXECUTABLE(dump978-rb ${SRC_FILES})


FIND_PACKAGE(Boost REQUIRED COMPONENTS system program_options regex filesystem)


TARGET_INCLUDE_DIRECTORIES(dump978-rb PRIVATE ./libs)

#OPTION(LTO "Compile and Link with Link-Time Optimization")
#IF (LTO)
#	ADD_DEFINITIONS(-DWITH_SOAPY)
#	TARGET_SOURCES(acarsdec PRIVATE soapy.c)
#	TARGET_LINK_LIBRARIES(acarsdec ${LIBSOAPY})
#ENDIF ()

FIND_LIBRARY(LIBSOAPY SoapySDR)
IF (NOT LIBSOAPY)
	MESSAGE(FATAL_ERROR "libSoapySDR path not found")
ENDIF ()
ADD_DEFINITIONS(-DWITH_SOAPY)
TARGET_SOURCES(dump978-rb PRIVATE soapy_source.cc)



########################################################################################################################
#   LINK LIBRARIES                                                                                                     #
########################################################################################################################

TARGET_LINK_LIBRARIES(dump978-rb PUBLIC ${LIBS})
TARGET_LINK_LIBRARIES(dump978-rb PRIVATE ${LIBSOAPY})
TARGET_LINK_LIBRARIES(dump978-rb PRIVATE Boost::system)
TARGET_LINK_LIBRARIES(dump978-rb PRIVATE Boost::program_options)
TARGET_LINK_LIBRARIES(dump978-rb PRIVATE Boost::regex)
TARGET_LINK_LIBRARIES(dump978-rb PRIVATE Boost::filesystem)


########################################################################################################################
#   PERFORM INSTALLATION                                                                                               #
########################################################################################################################

INSTALL(TARGETS dump978-rb
		RUNTIME DESTINATION bin
)
