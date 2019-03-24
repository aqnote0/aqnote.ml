#     Title: common used Makefile
#    Author: "Peng Li"<aqnote@aqnote.com>
#     CDate: 20180809
#     MDate:
# Copyright: http://aqnote.com/LICENSE
#
#

## module structure
INC_DIR		:= include
SRC_DIR		:= src
LIB_DIR		:= lib
BIN_DIR 	:= bin
BUILD_DIR 	:= build
DEPENDS_DIR := depends

## command
CC 		= gcc
CPP 	= g++
RM 		= rm -f

COMPILER = $(CC)
ifeq "cpp" "${MODULE_COMPILER}"
	COMPILER = $(CPP)
endif

## targets
TARGETS 	:= $(MODULE_OUTPUT)

## get c source files
C_SOURCES = $(wildcard $(SRC_DIR)/*.c)
OBJECTS = $(C_SOURCES:$(SRC_DIR)/%.c=$(BUILD_DIR)/%.o)

## get cpp source file
CPP_SOURCES = $(wildcard $(SRC_DIR)/*.cpp)
OBJECTS += $(CPP_SOURCES:$(SRC_DIR)/%.cpp=$(BUILD_DIR)/%.o)

## add static and dynamic
# -L/usr/lib64/mysql \
 -Wl,-Bstatic -lmysqlclient \
 -Wl,-Bdynamic -lz -lcrypt -lnsl -lm \
 -L/usr/lib64 -lssl -lcrypto

 ## add Include
 CFLAGS += -I./include

## add Source Depends
ifneq "" "$(MODULE_DEPENDS_PROJ)"
	CFLAGS += $(foreach module, $(MODULE_DEPENDS_PROJ), -I${PROJECT_MODULES_HOME}/${module}/include)
	LDFLAGS += $(foreach module, $(MODULE_DEPENDS_PROJ), ${PROJECT_MODULES_HOME}/${module}/lib/lib$(module).a)
endif

## add Binary Depends
DEPENDS = $(shell ls depends 2>/dev/null)
ifneq "" "$(DEPENDS)"
	CFLAGS += $(foreach module, $(DEPENDS), -I$(DEPENDS_DIR)/${module}/include)
	LDFLAGS += $(foreach module, $(DEPENDS), $(DEPENDS_DIR)/${module}/lib/lib$(module).a)
endif

## add System Depends
ifneq "" "$(MODULE_DEPENDS_NONSTD_PATH)"
	CFLAGS += $(foreach module, $(MODULE_DEPENDS_NONSTD_PATH), -I$(module)/include)
	LDFLAGS += $(foreach module, $(MODULE_DEPENDS_NONSTD_PATH), -L$(module)/lib)
	LDFLAGS += $(foreach lib, $(MODULE_DEPENDS_NONSTD_FILE), -l$(lib))
endif

### add pkg-config
ifneq "" "$(MODULE_DEPENDS_PKG)"
	CFLAGS += $(foreach config, $(MODULE_DEPENDS_PKG), $(shell pkg-config --cflags $(config))) 
	LDFLAGS += $(foreach config, $(MODULE_DEPENDS_PKG), $(shell pkg-config --libs $(config)))
endif

BUILD = RELEASE
ifeq "DEBUG" "${MODULE_BUILD}"
	BUILD = DEBUG
endif

.PHONY: all
all: $(BUILD)

.PHONY: RELEASE
RELEASE: CFLAGS += -O2 -D NDEBUG -Wall #-fwhole-program
RELEASE: $(TARGETS)

.PHONY: DEBUG
DEBUG: CFLAGS += -O0 -D_DEBUG -Wall -g -D_DEBUG=1
DEBUG: $(TARGETS)

$(MODULE_NAME).app: $(OBJECTS)
	@mkdir -p bin
	$(COMPILER) -o bin/$@ $(OBJECTS) $(LDFLAGS)

lib$(MODULE_NAME).so: $(OBJECTS)
	@mkdir -p lib
	$(COMPILER) -o lib/$@ $(OBJECTS) $(LDFLAGS) -shared

lib$(MODULE_NAME).a: $(OBJECTS)
	@mkdir -p lib
	ar $(ARFLAGS) lib/$@ $(OBJECTS)

## compile .c file
$(BUILD_DIR)/%.o : $(SRC_DIR)/%.c
	@mkdir -p $(BUILD_DIR)
	${CC} -o $@ -c $< -std=c99 ${CFLAGS}

## compile .cpp file
$(BUILD_DIR)/%.o : $(SRC_DIR)/%.cpp
	@mkdir -p $(BUILD_DIR)
	${CPP} -o $@ -c $< -std=c++11 ${CFLAGS}

.PHONY: clean
clean:
	@$(RM) -rf $(BUILD_DIR)
	@$(RM) -rf $(BIN_DIR)
	@$(RM) -rf $(LIB_DIR)

.PHONY: memcheck
memcheck:
	valgrind --tool=memcheck --leak-check=full ./$(TARGETS)

.PHONY: echo
echo:
	@echo $(DEPENDS_DIR)