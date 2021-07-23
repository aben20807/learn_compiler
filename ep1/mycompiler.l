/* Definition section */
%{
    #include <stdio.h>

    #define YY_NO_UNPUT
    #define YY_NO_INPUT
%}

/* Define regular expression label */
letter [a-zA-Z]
digit [0-9]
ident {letter}+
num_lit {digit}+

/* Rules section */
%%

"+"         { printf("%-8s \t %s\n", yytext, "ADD"); }
"-"         { printf("%-8s \t %s\n", yytext, "SUB"); }
"*"         { printf("%-8s \t %s\n", yytext, "MUL"); }
"/"         { printf("%-8s \t %s\n", yytext, "DIV"); }
"("         { printf("%-8s \t %s\n", yytext, "LPAR"); }
")"         { printf("%-8s \t %s\n", yytext, "RPAR"); }
"="         { printf("%-8s \t %s\n", yytext, "ASSIGN"); }
"\n"        { printf("%-8s \t %s\n", "\\n", "NEWLINE"); }
"decl"      { printf("%-8s \t %s\n", yytext, "DECL"); }
"print"     { printf("%-8s \t %s\n", yytext, "PRINT"); }
{ident}     { printf("%-8s \t %s\n", yytext, "IDENT"); }
{num_lit}   { printf("%-8s \t %s\n", yytext, "NUMLIT"); }

<<EOF>>     { yyterminate(); }
.           {;}

%%

/*  C Code section */
int yywrap(void)
{
    return 1;
}

int main(int argc, char *argv[])
{
    if (argc == 2) {
        yyin = fopen(argv[1], "r");
    } else {
        yyin = stdin;
    }
    yylex();
    printf("\nFinish scanning.");
    fclose(yyin);
    return 0;
}
