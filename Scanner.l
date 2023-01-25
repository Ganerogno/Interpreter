

%{
    #include <stdio.h>
    #include <stdlib.h>
    #include <string.h>
    #include "Parser.tab.h"
    extern FILE* yyIn;
    extern FILE* yyOut;
%}

%%
"VAR" {return VAR;}
"END_VAR" {return END_VAR;}
": INT" {return INITIAL_FLAG;}
"IF" {return IF;};
"THEN" {return THEN;};
"ELSE" {return ELSE;}
"ELSEIF" {return ELSEIF;}
"END_IF" {return END_IF;}
"FOR" {return FOR;}
"TO" {return TO;}
"DO" {return DO;}
"END_FOR" {return END_FOR;}
":=" {return EQUAL_SIGN;}
"=" {strcpy(yylval.str, "=="); return SIGN;}
"<>" {strcpy(yylval.str, "!="); return SIGN;}


[ \n\t;] {}
[a-zA-Z][a-zA-Z0-9]* {strcpy(yylval.str, yytext); return VARIABLE;}
[0-9]+ {strcpy(yylval.str, yytext); return NUM;}
["+""-""*""/"">""<"">=""<="] {strcpy(yylval.str, yytext); return SIGN;}

%%
int yywrap(void) {return 1;}

