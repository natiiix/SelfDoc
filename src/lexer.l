%option noyywrap

%{

#define YY_DECL int yylex()

#include "selfdoc.tab.h"

int row = 0;
int column = 0;
int eof = 0;

void count(void);

%}

%%

<<EOF>>                 { return eof++ == 0 ? NEWLINE : 0; }
"let"                   { count(); return KW_LET; }
"be"                    { count(); return KW_BE; }
"print"                 { count(); return KW_PRINT; }
"sum"                   { count(); return KW_SUM; }
"product"               { count(); return KW_PRODUCT; }
"of"                    { count(); return KW_OF; }
"and"                   { count(); return KW_AND; }
"plus"                  { count(); return KW_PLUS; }
"minus"                 { count(); return KW_MINUS; }
"times"                 { count(); return KW_TIMES; }
"over"                  { count(); return KW_OVER; }
-?[0-9]+\.[0-9]+        { count(); yylval.str_val = strdup(yytext); return LIT_FLOAT; }
-?[0-9]+                { count(); yylval.str_val = strdup(yytext); return LIT_INT; }
[a-zA-Z_][a-zA-Z0-9_]*  { count(); yylval.str_val = strdup(yytext); return IDENTIFIER; }
\n                      { count(); return NEWLINE; }
[ \t\r]                 { count(); }
.                       { fprintf(stderr, "Unexpected character: \'%s\' at line %i column %i\n", yytext, row + 1, column + 1); exit(-1); }

%%

void count(void)
{
    // printf("[%s]\n", yytext);

    for (int i = 0; yytext[i] != '\0'; i++)
    {
        if (yytext[i] == '\n')
        {
            column = 0;
            row++;
        }
        else
        {
            column++;
        }
    }
}
