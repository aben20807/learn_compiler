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
    static int insert_symbol(const char* id_name);
    static int lookup_symbol(const char* id_name);
    static void dump_symbol();

    /* Global variables */
    int example_symbol_cnt = 0;
    #define MAX_SYMBOL_NUM 10
    char *example_symbol[MAX_SYMBOL_NUM] = {};

    const char* get_op_name(op_t op) {
        switch (op) {
            case OP_ADD:
                return "ADD";
            case OP_SUB:
                return "SUB";
            case OP_MUL:
                return "MUL";
            case OP_DIV:
                return "DIV";
            default:
                return "unknown";
        }
    }
%}

%error-verbose

/* Use variable or self-defined structure to represent
 * nonterminal and token type
 */
%union {
    int val;
    char *id_name;
    op_t op;
}

/* Token without return */
%token DECL PRINT NEWLINE

/* Token with return, which need to sepcify type */
%token <val> NUMLIT
%token <id_name> IDENT

/* Nonterminal with return, which need to sepcify type */
%type <op> AddOp MulOp

/* Yacc will start at this nonterminal */
%start Program

/* Grammar section */
%%

Program
    : StatementList
;

StatementList
    : Statement StatementList
    |
;

Statement
    : DeclStmt
    | PrintStmt
;

DeclStmt
    : DECL IDENT '=' Expression NEWLINE {
        int ref = insert_symbol($<id_name>2);
        printf("IDENT %s, ref: %d\n", $<id_name>2, ref);
        printf("STORE\n");
        free($<id_name>2);
    }
;

PrintStmt
    : PRINT Expression NEWLINE {
        printf("PRINT\n");
    }
;

Expression
    : AddExpr
;

AddExpr
    : AddExpr AddOp MulExpr {
        printf("%s\n", get_op_name($<op>2));
    }
    | MulExpr
;

AddOp
    : '+'  {
        $<op>$ = OP_ADD;
    }
    | '-' {
        $<op>$ = OP_SUB;
    }
;

MulExpr
    : MulExpr MulOp Operand {
        printf("%s\n", get_op_name($<op>2));
    }
    | Operand
;

MulOp
    : '*' {
        $<op>$ = OP_MUL;
    }
    | '/' {
        $<op>$ = OP_DIV;
    }
;

Operand
    : NUMLIT {
        printf("NUMLIT %d\n", $<val>1);
    }
    | IDENT {
        int ref = lookup_symbol($<id_name>1);
        printf("IDENT %s, ref: %d\n", $<id_name>1, ref);
        printf("LOAD\n");
        free($<id_name>1);
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

    create_symbol();

    yyparse();

    printf("Total lines: %d\n", yylineno);

    dump_symbol();
    fclose(yyin);
    return 0;
}

static void create_symbol()
{
    printf("> Create symbol table\n");
    // do nothing...
}

static int insert_symbol(const char* id_name)
{
    printf("> Insert {%s} into symbol table; assign it as ref {%d}\n", 
        id_name, example_symbol_cnt);
    example_symbol[example_symbol_cnt] = strdup(id_name);
    example_symbol_cnt++;
    return example_symbol_cnt - 1;
}

static int lookup_symbol(const char* id_name)
{
    printf("> Lookup in symbol table\n");
    for (int i = 0; i < example_symbol_cnt; i++) {
        if (strcmp(id_name, example_symbol[i]) == 0) {
            return i;
        }
    }
    printf("{%s} not found in symbol table\n", id_name);
    return -1;
}
static void dump_symbol()
{
    printf("> Dump symbol table\n");
    for (int i = 0; i < example_symbol_cnt; i++) {
        free(example_symbol[i]);
    }
}
