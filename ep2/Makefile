CC := gcc
CFLAGS := -Wall
YFLAG := -d -v
LEX_SRC := mycompiler.l
YAC_SRC := mycompiler.y
HEADER := common.h
TARGET := myparser

all: ${TARGET}

${TARGET}: lex.yy.c y.tab.c
	${CC} ${CFLAGS} -o $@ $^

lex.yy.c: ${LEX_SRC} ${HEADER}
	lex $<

y.tab.c: ${YAC_SRC} ${HEADER}
	yacc ${YFLAG} $<

clean:
	rm -f ${TARGET} y.tab.* y.output lex.*
