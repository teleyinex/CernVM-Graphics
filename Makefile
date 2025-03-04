#BOINC settings - change BOINC_DIR to your liking
BOINC_DIR = ../..
BOINC_API_DIR = $(BOINC_DIR)/api
BOINC_LIB_DIR = $(BOINC_DIR)/lib

#JsonCpp
JSONCPP_INC_DIR = JsonCpp/include
JSONCPP_LIB_DIR = JsonCpp/libs/linux-gcc-*

OPENGL_LIBS = -lGL -lglut -lGLU
CURL_LIBS = `curl-config --libs`
LIBRARIES = $(OPENGL_LIBS) -lpng $(CURL_LIBS)

CXXFLAGS = -g -Wall

BOINC_INCLUDE_DIRS = -I$(BOINC_DIR) \
    -I$(BOINC_API_DIR) \
    -I$(BOINC_LIB_DIR)

BOINC_LIBRARY_DIRS = -L$(BOINC_DIR) \
    -L$(BOINC_API_DIR) \
    -L$(BOINC_LIB_DIR)

PROGS = jsoncpp screensaver

all: $(PROGS)
.PHONY: jsoncpp

clean: 
	rm screensaver *.o
	cd JsonCpp; python scons.py -c platform=linux-gcc

jsoncpp:
	cd JsonCpp; python scons.py platform=linux-gcc

networking.o: networking.cpp 
	g++ -c $(CXXFLAGS) \
	$(BOINC_INCLUDE_DIRS) -I$(JSONCPP_INC_DIR) \
	-o networking.o networking.cpp

resources.o: resources.cpp 
	g++ -c $(CXXFLAGS) \
	$(BOINC_INCLUDE_DIRS) -I$(JSONCPP_INC_DIR) \
        -o resources.o resources.cpp

objects.o: objects.cpp 
	g++ -c $(CXXFLAGS) \
	$(BOINC_INCLUDE_DIRS) -I$(JSONCPP_INC_DIR) \
        -o objects.o objects.cpp

sprites.o: sprites.cpp 
	g++ -c $(CXXFLAGS) \
	$(BOINC_INCLUDE_DIRS) -I$(JSONCPP_INC_DIR) \
        -o sprites.o sprites.cpp

graphics.o: graphics.cpp 
	g++ -c $(CXXFLAGS) \
	$(BOINC_INCLUDE_DIRS) -I$(JSONCPP_INC_DIR) \
        -o graphics.o graphics.cpp

errors.o: errors.cpp 
	g++ -c $(CXXFLAGS) \
	$(BOINC_INCLUDE_DIRS) -I$(JSONCPP_INC_DIR) \
        -o errors.o errors.cpp

main.o: main.cpp 
	g++ -c $(CXXFLAGS) \
	$(BOINC_INCLUDE_DIRS) -I$(JSONCPP_INC_DIR) \
        -o main.o main.cpp 

screensaver: main.o graphics.o sprites.o objects.o resources.o networking.o errors.o $(BOINC_LIB_DIR)/libboinc.a $(BOINC_API_DIR)/libboinc_graphics2.a JsonCpp/libs/*
	g++ $(CXXFLAGS) -o screensaver  \
	main.o graphics.o objects.o resources.o sprites.o networking.o \
        errors.o \
        -pthread \
	$(BOINC_API_DIR)/libboinc_graphics2.a \
	$(BOINC_API_DIR)/libboinc_api.a \
	$(BOINC_LIB_DIR)/libboinc.a \
	$(JSONCPP_LIB_DIR)/libjson_linux-gcc-*_libmt.a \
	$(LIBRARIES)

