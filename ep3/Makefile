CC := gcc
CFLAGS := -Wall
YFLAG := -d -v
LEX_SRC := mycompiler.l
YAC_SRC := mycompiler.y
HEADER := common.h
COMPILER := mycompiler
JAVABYTECODE := bytecode.j
EXEC := Main

all: ${COMPILER}

${COMPILER}: lex.yy.c y.tab.c
	${CC} ${CFLAGS} -o $@ $^

lex.yy.c: ${LEX_SRC} ${HEADER}
	lex $<

y.tab.c: ${YAC_SRC} ${HEADER}
	yacc ${YFLAG} $<

${JAVABYTECODE}: ${COMPILER}
ifeq (,$(wildcard ${JAVABYTECODE}))
	@echo "${JAVABYTECODE} does not exist."
endif

${EXEC}.class: ${JAVABYTECODE}
	@java -jar jasmin.jar -g ${JAVABYTECODE}

run: ${EXEC}.class
	@java ${EXEC} || java -Xverify:none ${EXEC}

clean:
	rm -f ${COMPILER} y.tab.* y.output lex.* ${EXEC}.class *.j
