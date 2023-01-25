%{
    #include <stdio.h>

    #include "lex.yy.c"
    
    extern int yylex();
    extern FILE* yyin;
    extern FILE* yyout;
    int yyerror(char* s);
    
%}

%union { char str[1024];}
%start input
%token<str> NUM
%token<str> VARIABLE SIGN EQUAL_SIGN
%token IF THEN ELSE ELSEIF END_IF
%token VAR END_VAR INITIAL_FLAG
%token FOR END_FOR TO DO

%type<str> command command_list expression if else start_if
%type<str> initialization initialization_list assign

%%

    input: command_list 
    {fprintf(yyout, $1);fprintf(yyout, "\n\treturn 0;\n");return 0;}

    command_list: command 
    {strcpy($$, $1);}
    | command command_list 
    {strcpy($$, $1);strcat($$, "\n\t");strcat($$, $2);}

    command: VAR initialization_list END_VAR 
    {strcpy($$,"\t"); strcat($$,$2); strcat($$,";\n");}
    | start_if
    {strcpy($$,$1);};
    | VARIABLE assign
    {strcpy($$,$1); strcat($$,$2); strcat($$,";\n\t");}
    | FOR VARIABLE assign TO expression DO command_list END_FOR
    {
        strcpy($$,"for(");
        strcat($$,$2);
        strcat($$,$3);
        strcat($$,";");
        strcat($$,$2);
        strcat($$,"<");
        strcat($$,$5);
        strcat($$,";");
        strcat($$,$2);
        strcat($$,"++)\n\t{\n\t");
        strcat($$,$7);
        strcat($$,"}\n\t");
    }

    expression: NUM {strcpy($$,$1);}
    | VARIABLE {strcpy($$,$1);}
    | expression SIGN expression 
    {strcpy($$,$1); strcat($$,$2); strcat($$,$3);}
    
    
    initialization_list:
    initialization 
    {strcpy($$,$1);}
    | initialization initialization_list
    {strcpy($$, $1);strcat($$, ";\n\t");strcat($$,$2);}

    initialization: VARIABLE INITIAL_FLAG assign
    {strcpy($$, "int ");strcat($$,$1); strcat($$,$3);}

    assign: EQUAL_SIGN expression
    {strcpy($$, " = "); strcat($$,$2);}

    start_if: if END_IF
    {strcpy($$, $1);strcat($$, "}");}
    | if else END_IF
    {strcpy($$, $1);strcat($$,$2);strcat($$, "\n\t");}

    else: ELSE command_list
    {strcpy($$,"}\n\telse\n\t{\n\t");strcat($$,$2);strcat($$, "}\n\t");}
    | ELSEIF expression THEN command_list
    {strcpy($$,"}\n\telse if( ");strcat($$,$2);strcat($$,")\n\t{\n\t");
    strcat($$,$4);}
    | ELSEIF expression THEN command_list else
    {strcpy($$,"}\n\telse if( ");strcat($$,$2);strcat($$,")\n\t{\n\t");
    strcat($$,$4); strcat($$,$5);}

    if: IF expression THEN command_list
    {strcpy($$, "if(");strcat($$,$2);
    strcat($$, ")\n\t{\n\t");strcat($$,$4);strcat($$, "\n\t");}
%%

int main(void)
{
    yyin = fopen("input.txt","r");
    yyout = fopen("output.txt","w");
	fprintf(yyout, "#include <stdio.h>\n#include <stdlib.h>\n\nint main()\n{\n");
    yyparse();
	fprintf(yyout, "}");
    fclose(yyin);
    fclose(yyout);
    return 0;
}

int yyerror(char* s)
{
    fprintf(yyout, "%s\n", s);
    return 0;
}