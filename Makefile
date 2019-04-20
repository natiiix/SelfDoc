PROJECT_NAME=selfdoc
SRC_DIR=src/
BIN_DIR=bin/
TMP_DIR=tmp/
TEST_DIR=test/
LEXER=lexer
PARSER=parser

.PHONY: all
all: ${BIN_DIR}${PROJECT_NAME}

${BIN_DIR}${PROJECT_NAME}: makedirs ${TMP_DIR}${PROJECT_NAME}.tab.c ${TMP_DIR}${PROJECT_NAME}.tab.h ${TMP_DIR}lex.yy.c
	gcc -Wall -Wextra -g -o ${BIN_DIR}${PROJECT_NAME} ${TMP_DIR}${PROJECT_NAME}.tab.c ${TMP_DIR}lex.yy.c

${TMP_DIR}${PROJECT_NAME}.tab.c: ${SRC_DIR}${PARSER}.y
	yacc -Wall -v -o ${TMP_DIR}${PROJECT_NAME}.tab.c ${SRC_DIR}${PARSER}.y

${TMP_DIR}lex.yy.c: ${SRC_DIR}${LEXER}.l
	lex -o ${TMP_DIR}lex.yy.c src/${LEXER}.l

.PHONY: makedirs
makedirs:
	mkdir -p ${TMP_DIR}
	mkdir -p ${BIN_DIR}

.PHONY: clean
clean:
	rm ${TMP_DIR}*
	rm ${BIN_DIR}*

.PHONY: test
test: ${BIN_DIR}${PROJECT_NAME} $(wildcard ${TEST_DIR}*)
	for f in $(wildcard ${TEST_DIR}*); do \
		${BIN_DIR}${PROJECT_NAME} < $$f > ${TMP_DIR}test.c; \
		gcc -o ${TMP_DIR}test.out ${TMP_DIR}test.c; \
		${TMP_DIR}test.out; \
	done
