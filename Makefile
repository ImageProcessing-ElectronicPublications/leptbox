PNAME=leptbox
CC=gcc
CFLAGS=-Wall -std=c99 -I/usr/include/leptonica
LDFLAGS=-llept -s
RM=rm -f

all: $(PNAME)

$(PNAME): $(PNAME).c
	$(CC) $(CFLAGS) $^ -o $@ $(LDFLAGS)

clean:
	$(RM) $(PNAME)
