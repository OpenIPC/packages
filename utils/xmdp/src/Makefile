all: xmdp

xmdp: xmdp.o netip.o utils.o cjson/cJSON.c
	$(CC) -o $@ $^

clean:
	-rm xmdp *.o
