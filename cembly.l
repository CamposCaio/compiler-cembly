%{
/* comentarios */
#include<math.h>
#include<stdio.h>
#include<stdlib.h>
#include<string.h>
#include <cstdio>
#include <iostream>
using namespace std;
extern "C" int yylex();

#include "cembly.h"
#include "cembly.tab.h"


%}

%%
"for" 		{return FOR;}
"while"	{return WHILE;}
"if"		{return IF;}
"else"		{return ELSE;}
"int"  	{return INT;}
"char"		{return CHAR;}
"float"  	{return FLOAT;}
"write"  	{return WRITE;}
"read_int"  	{return READ_INT;}
"read_float"  	{return READ_FLOAT;}
"read_char"  	{return READ_CHAR;}
"main"	{return MAIN;}
"endmain"		{return ENDMAIN;}
"start"	{return START;}
"end"	{return END;}

[-+]?[0-9]+("."[0-9]*)?([eE]"-"?[0-9]*)? { yylval.pont->val = atof(yytext);
                                           return NUM;
                                         }
[a-zA-Z][a-zA-z0-9]* { strncpy(yylval.pont->nome, yytext, 256);
                       return LETRA;
                     }
"<="    {return MEI;}
">="    {return MI;}
"=="    {return II;}
"!="    {return TI;}
">"	{return MA;}
"<"	{return ME;}

"="|"+"|"-"|"*"|"/"|"%"       { return *yytext; }

[ \t\n]  /* Ignora */
.      { return *yytext; }
%%
int yywrap(void){
  return 1; 
}  
