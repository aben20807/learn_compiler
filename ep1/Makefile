CC := gcc
CFLAGS := -Wall
SRC := mycompiler.l
TARGET := myscanner

all: ${TARGET}

${TARGET}: lex.yy.c
	@${CC} ${CFLAGS} -o $@ $<

lex.yy.c: ${SRC}
	@lex ${SRC}

clean:
	@rm -f ${TARGET} lex.*
