/*	Definition section */
%{
    #include "common.h" //Extern variables that communicate with lex
    // #define YYDEBUG 1
    // int yydebug = 1;

    extern int yylineno;
    extern int yylex();
    extern FILE *yyin;

    void yyerror (char const *s)
    {
        printf("error:%d: %s\n", yylineno, s);
    }


    /* Symbol table function - you can add new function if needed. */
    static void create_symbol(/* ... */);
    static void insert_symbol(/* ... */);
    static void lookup_symbol(/* ... */);
    static void dump_symbol(/* ... */);
%}

%error-verbose

/* Use variable or self-defined structure to represent
 * nonterminal and token type
 */
%union {
    int val;
    char *id_name;
    /* ... */
}

/* Token without return */
%token DECL PRINT NEWLINE

/* Token with return, which need to sepcify type */
%token <val> NUMLIT
%token <id_name> IDENT

/* Nonterminal with return, which need to sepcify type */

/* Yacc will start at this nonterminal */
%start Program

/* Grammar section */
%%

Program
    : Statement Program
    |
;

Statement
    : DeclStmt 
    | PrintStmt
;

DeclStmt
    : DECL IDENT '=' Expression NEWLINE
;

PrintStmt
    : PRINT Expression NEWLINE
;

Expression
    : AddExpr
;

AddExpr
    : AddExpr AddOp MulExpr
    | MulExpr
;

AddOp
    : '+' 
    | '-'
;

MulExpr
    : MulExpr MulOp Operand
    | Operand
;

MulOp
    : '*' 
    | '/'
;

Operand
    : NUMLIT {
        printf("NUMLIT %d\n", yylval.val);
    }
    | IDENT {
        printf("IDENT %s\n", yylval.id_name);
    }
    | '(' Expression ')'
;


%%

/* C code section */
int main(int argc, char *argv[])
{
    if (argc == 2) {
        yyin = fopen(argv[1], "r");
    } else {
        yyin = stdin;
    }

    yyparse();

	printf("Total lines: %d\n", yylineno);
    fclose(yyin);
    return 0;
}
