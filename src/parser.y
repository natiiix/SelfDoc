%defines

%define parse.error verbose

%{

#include <stdio.h>
#include <stdlib.h>
#include <stdarg.h>
#include <stdbool.h>

extern int yylex();
extern int yyparse();
extern FILE* yyin;

void yyerror(const char* const str);

const char* strformat(const char* const format, ...);
const char* getincludes(void);

const char* const strempty = "";

bool include_stdio = false;

%}

%union
{
	// double num_val;
    const char* str_val;
}

%token<str_val> LIT_FLOAT LIT_INT IDENTIFIER

%token NEWLINE
%token KW_LET KW_BE KW_PRINT KW_SUM KW_PRODUCT KW_OF KW_AND KW_PLUS KW_MINUS KW_TIMES KW_OVER

%type<str_val> statement_block statement top_level sum_list product_list plus_minus times_over single atomic

%start translation_unit

%%

translation_unit
    : statement_block { printf("%sint main(void){%sreturn 0;}", getincludes(), $1); }
    ;

statement_block
    : NEWLINE { $$ = strempty; }
    | NEWLINE statement_block { $$ = $2; }
    | statement { $$ = $1; }
    | statement statement_block { $$ = strformat("%s%s", $1, $2); }
    ;

statement
    : KW_LET IDENTIFIER KW_BE top_level NEWLINE { $$ = strformat("double %s=%s;", $2, $4); }
    | KW_PRINT top_level NEWLINE { include_stdio = true; $$ = strformat("printf(\"%%g\\n\",%s);", $2); }
    ;

top_level
    : plus_minus { $$ = $1; }
    ;

sum_list
    : sum_list KW_AND top_level { $$ = strformat("(%s+%s)", $1, $3); }
    | top_level { $$ = $1; }
    ;

product_list
    : product_list KW_AND top_level { $$ = strformat("(%s*%s)", $1, $3); }
    | top_level { $$ = $1; }
    ;

plus_minus
    : plus_minus KW_PLUS times_over { $$ = strformat("(%s+%s)", $1, $3); }
    | plus_minus KW_MINUS times_over { $$ = strformat("(%s-%s)", $1, $3); }
    | times_over { $$ = $1; }
    ;

times_over
    : times_over KW_TIMES single { $$ = strformat("(%s*%s)", $1, $3); }
    | times_over KW_OVER single { $$ = strformat("(%s/%s)", $1, $3); }
    | single { $$ = $1; }
    ;

single
    : atomic { $$ = $1; }
    | KW_SUM KW_OF sum_list { $$ = $3; }
    | KW_PRODUCT KW_OF product_list { $$ = $3; }
    ;

atomic
    : LIT_FLOAT { $$ = $1; }
    | LIT_INT { $$ = strformat("%s.0", $1); }
    | IDENTIFIER { $$ = $1; }
    ;

%%

extern int row;
extern int column;

void yyparse_loop(void)
{
	do
	{
		yyparse();
	}
	while(!feof(yyin));
}

int main(const int argc, const char* const* const argv)
{
    if (argc == 1)
    {
	    yyin = stdin;
        yyparse_loop();
    }
    else
    {
        for (int i = 1; i < argc; i++)
        {
            yyin = fopen(argv[i], "r");
            yyparse_loop();
        }
    }

	return 0;
}

void yyerror(const char* const str)
{
	fprintf(stderr, "Parse error at line %i column %i: %s\n", row + 1, column + 1, str);
	exit(-1);
}

const char* strformat(const char* const format, ...)
{
    va_list args;
    va_start(args, format);

    const int len = vsnprintf(NULL, 0, format, args);
    char* const str = (char*)malloc(len + 1);

    if (str == NULL)
    {
        fprintf(stderr, "Unable to allocate memory for string\n");
        exit(-1);
    }

    va_end(args);
    va_start(args, format);

    if (vsnprintf(str, len + 1, format, args) != len)
    {
        fprintf(stderr, "Unexpected string length\n");
        exit(-1);
    }

    va_end(args);

    str[len] = '\0';
    return str;
}

const char* getincludes(void)
{
    return strformat("%s", include_stdio ? "#include <stdio.h>\n" : strempty);
}
