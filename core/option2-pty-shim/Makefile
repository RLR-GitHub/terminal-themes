# Makefile for PTY Wrapper

CC = gcc
CFLAGS = -Wall -Wextra -O2
TARGET = pty-wrapper

# Platform-specific libraries
UNAME_S := $(shell uname -s)
ifeq ($(UNAME_S),Linux)
    LDFLAGS = -lutil
endif
ifeq ($(UNAME_S),Darwin)
    LDFLAGS = -lutil
endif

.PHONY: all clean install uninstall

all: $(TARGET)

$(TARGET): pty-wrapper.c
	$(CC) $(CFLAGS) -o $(TARGET) pty-wrapper.c $(LDFLAGS)

clean:
	rm -f $(TARGET)

install: $(TARGET)
	install -d $(DESTDIR)/usr/local/bin
	install -m 755 $(TARGET) $(DESTDIR)/usr/local/bin/
	install -m 755 command-hooks.sh $(DESTDIR)/usr/local/bin/rory-terminal-hooks
	install -m 755 output-parser.sh $(DESTDIR)/usr/local/bin/rory-terminal-parser
	install -d $(DESTDIR)/usr/local/etc/rory-terminal
	install -m 644 color-rules.json $(DESTDIR)/usr/local/etc/rory-terminal/

uninstall:
	rm -f $(DESTDIR)/usr/local/bin/$(TARGET)
	rm -f $(DESTDIR)/usr/local/bin/rory-terminal-hooks
	rm -f $(DESTDIR)/usr/local/bin/rory-terminal-parser
	rm -rf $(DESTDIR)/usr/local/etc/rory-terminal

test: $(TARGET)
	./$(TARGET) echo "Testing PTY wrapper"
	./$(TARGET) ls -la

.DEFAULT_GOAL := all

