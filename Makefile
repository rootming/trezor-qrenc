CC=gcc
EMCC=emcc
CHECKLIBS = -lcheck -lrt -lpthread -lm

OPTFLAGS  = -Os -g

EMFLAGS = -O3

CFLAGS   += $(OPTFLAGS) \
            -W \
            -Wall \
            -Wextra \
            -Wimplicit-function-declaration \
            -Wredundant-decls \
            -Wstrict-prototypes \
            -Wundef \
            -Wshadow \
            -Wpointer-arith \
            -Wformat \
            -Wreturn-type \
            -Wsign-compare \
            -Wmultichar \
            -Wformat-nonliteral \
            -Winit-self \
            -Wuninitialized \
            -Wformat-security \
            -DQR_MAX_VERSION=0

all: test tests

%.bc: %.c
	$(EMCC) $(EMFLAGS) -o $@ -c $<

%.o: %.c
	$(CC) -o $@ -c $<

test: qr_encode.o test.o
	$(CC) $(CFLAGS) qr_encode.o test.o -o test


test_arg.js: qr_encode.bc test_arg.bc moduleinit.js.head
	$(EMCC) $(EMFLAGS) qr_encode.bc test_arg.bc -o test_arg.js --pre-js moduleinit.js.head

qr.js: qr.js.head qr.js.foot test_arg.js
	cat qr.js.head test_arg.js qr.js.foot > qr.js

tests: qr_encode.o tests.o
	$(CC) $(CFLAGS) qr_encode.o tests.o $(CHECKLIBS) -o tests

clean:
	rm -f *.o *.js *.bc *.js.mem test tests
