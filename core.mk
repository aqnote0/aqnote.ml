#     Title: common used Makefile
#    Author: "Peng Li"<aqnote@qq.com>
#     CDate: 20180809
#     MDate:
# Copyright: http://aqnote.com/LICENSE
#
#

## command
CC 		= gcc
CPP 	= g++
RM 		= rm -f
AQN_APP_COMPILER = $(CC)

## source file path
SRC_PATH 	:= .

## target exec file name
TARGET 		:= main.app


AQN_APP_SOURCE = $(APP_SOURCE)
## get all source files
SRCS += $(wildcard $(SRC_PATH)/*.$(AQN_APP_SOURCE))
## all .0 based on all .c .cpp
OBJS = $(SRCS:.$(AQN_APP_SOURCE)=.o)


## defaug flag
AQN_APP_DEBUG = $(APP_DEBUG)

## add Include and Library
AQN_APP_HOME := $(APP_HOME)
AQN_APP_LIBS := $(APP_LIBS)
INCLUDE_PATH += $(foreach dir, $(AQN_APP_HOME), $(dir)/include)
LIBRARY_PATH += $(foreach dir, $(AQN_APP_HOME), $(dir)/lib)

ifeq (1, ${AQN_APP_DEBUG})
CFLAGS += -D_DEBUG -O0 -g -D_DEBUG=1
endif

CFLAGS += $(foreach dir, $(INCLUDE_PATH), -I$(dir))
LDFLAGS += $(foreach dir, $(LIBRARY_PATH), -L$(dir))
LDFLAGS += $(foreach lib, $(AQN_APP_LIBS), -l$(lib))

ifeq (cpp, ${AQN_APP_SOURCE})
AQN_APP_COMPILER = $(CPP)
CFLAGS += -std=c++11
endif

## pkg-config
AQN_APP_PKG := $(APP_PKG)
CFLAGS += $(foreach config, $(AQN_APP_PKG), $(shell pkg-config --cflags $(config))) 
LDFLAGS += $(foreach config, $(AQN_APP_PKG), $(shell pkg-config --libs $(config)))

all: build

build: 
	$(AQN_APP_COMPILER) -c $(CFLAGS) $(SRCS)
	$(AQN_APP_COMPILER) -o $(TARGET) $(CFLAGS) $(LDFLAGS) $(OBJS)
#$(RM) $(OBJS)

clean:
	$(RM) $(OBJS) $(TARGET)

memcheck:
	valgrind --tool=memcheck --leak-check=full ./$(TARGET) 
