CC = gcc
CFLAGS = -O3 -fPIC -march=native -mtune=native
LUA_INCDIR = /usr/include/lua5.1
LUA_LIBDIR = /usr/lib/x86_64-linux-gnu

# Check for SIMD support
ifneq (,$(findstring avx2,$(shell cat /proc/cpuinfo)))
    CFLAGS += -mavx2
endif

ifneq (,$(findstring avx,$(shell cat /proc/cpuinfo)))
    CFLAGS += -mavx
endif

all: p9ml_prime.so test_standalone

p9ml_prime.so: lua_p9ml_prime.c p9ml_prime_factorization.c
	$(CC) $(CFLAGS) -shared -I$(LUA_INCDIR) -o p9ml_prime.so lua_p9ml_prime.c

test_standalone: p9ml_prime_factorization.c
	$(CC) $(CFLAGS) -DSTANDALONE_TEST -o test_standalone p9ml_prime_factorization.c

clean:
	rm -f p9ml_prime.so test_standalone

test: test_standalone
	./test_standalone

install: p9ml_prime.so
	cp p9ml_prime.so /usr/local/lib/lua/5.1/

.PHONY: all clean test install