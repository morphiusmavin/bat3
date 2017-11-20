GNUCC = gcc
GNUCFLAGS = -std=gnu99 -Wstrict-prototypes
#GNULDFLAGS = -static
GNULDFLAGS = -I.
#GNULDFLAGS_T = ${GNULDFLAGS} -pthread

#####################################################
CC = ${GNUCC}
CFLAGS = ${GNUCFLAGS}
LDFLAGS = ${GNULDFLAGS}
LDFLAGS_T = ${GNULDFLAGS_T}

all : test_64

ByteArray.o: ByteArray.c ByteArray.h base.h
	${CC} ${CFLAGS} ${LDFLAGS} -c ByteArray.c

IntArray.o: IntArray.c IntArray.h
	${CC} ${CFLAGS} ${LDFLAGS} -c IntArray.c

net1.o: net1.c net1.h
	${CC} ${CFLAGS} ${LDFLAGS} -c net1.c

test_x64.o: test_x64.c file1.h bat3.h net1.h
	${CC} ${CFLAGS} ${LDFLAGS} -c test_x64.c

file1.o: file1.c base.h IntArray.h ByteArray.h
	${CC} ${CFLAGS} ${LDFLAGS} -c file1.c

test_64: net1.o file1.o ByteArray.o IntArray.o test_x64.o
	${CC} net1.o file1.o IntArray.o ByteArray.o test_x64.o  -o test_64

clean:
	rm -f *.o *~ *# core  \
	test_64 out.txt
