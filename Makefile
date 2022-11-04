# SOIL makefile for linux and MacOS
# Type 'make' then 'make install' to complete the installation of the library

ifeq ($(OS),Windows_NT)
ARCHI := Windows
else
ARCHI := $(shell sh -c 'uname -s 2>/dev/null || echo Unknown')
endif

# For 'make install' to work, set LOCAL according to your system configuration
PREFIX = /usr/local
LOCAL = $(PREFIX)

LIB = libSOIL.a
INC = SOIL.h

SRCDIR = src
INCDIR = src
LIBDIR = build
OBJDIR = build

ifeq ($(ARCHI),Darwin)
CFLAGS = -fPIC -O2 -Wall -Wextra -DGL_SILENCE_DEPRECATION
LDFLAGS += -framework OpenGL -framework CoreFoundation
else
CFLAGS = -fPIC -O2 -Wall -Wextra
endif

CFLAGS += -Iinclude/SOIL

DELETER ?= rm -fr
COPIER ?= cp

SRCNAMES = \
  image_helper.c \
  stb_image_aug.c  \
  image_DXT.c \
  SOIL.c \

OBJ = $(addprefix $(OBJDIR)/, $(notdir $(SRCNAMES:.c=.o)))
BIN = $(LIBDIR)/$(LIB)

all: $(BIN)

$(BIN): $(OBJ)
	mkdir -p $(LIBDIR)
	$(DELETER) $(BIN)
	ar r $(BIN) $(OBJ)
	ranlib $(BIN)
	@echo -------------------------------------------------------------------
	@echo Done. As root, type 'make install' to install the library.

$(OBJDIR)/%.o: $(SRCDIR)/%.c
	mkdir -p $(OBJDIR)
	$(CC) $(CFLAGS) -o $@ -c $<

clean:
	$(DELETER) $(OBJDIR)

$(LOCAL)/lib/:
	mkdir $(LOCAL)/lib

$(LOCAL)/include/:
	mkdir $(LOCAL)/include

install: $(BIN) $(LOCAL)/lib/ $(LOCAL)/include/
	@echo Installing to: $(LOCAL)/lib and $(LOCAL)/include...
	@echo -------------------------------------------------------------------
	$(COPIER) $(BIN) $(LOCAL)/lib/
	$(COPIER) $(INCDIR)/$(INC) $(LOCAL)/include/
	@echo -------------------------------------------------------------------
	@echo SOIL library installed. Enjoy!

uninstall:
	$(DELETER) $(LOCAL)/include/$(INC) $(LOCAL)/lib/$(LIB)
	@echo -------------------------------------------------------------------
	@echo SOIL library uninstalled.

.PHONY: all clean install uninstall
