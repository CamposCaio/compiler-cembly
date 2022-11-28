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
"FOR" 		{return FOR;}
"LOOP"	{return LOOP;}
"IF"		{return IF;}
"ELSE"		{return ELSE;}
"INT"  	{return INT;}
"CHAR"		{return CHAR;}
"FLOAT"  	{return FLOAT;}
"WRITE"  	{return WRITE;}
"READ_INT"  	{return READ_INT;}
"READ_FLOAT"  	{return READ_FLOAT;}
"READ_CHAR"  	{return READ_CHAR;}
"START"	{return MAIN;}
"FINISH"		{return ENDMAIN;}
"BEGIN"	{return START;}
"END"	{return END;}

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
