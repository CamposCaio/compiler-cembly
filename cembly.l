%{
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

/*Tipos primitivos*/

[ \t\n];                        /*Ignorar*/
[0-9]                           {return TK_DIGITO;}
[a-zA-Z]                        {return TK_LETRA;}

/*Tipos de dado*/

[-+]?[0-9]+                    {yylval.pont->val = atof(yytext);
                                return TK_INT;}
[-+]?[0-9]+("."([0-9]+))?      {yylval.pont->val = atof(yytext);
                                return TK_FLOAT;}
("'")[a-zA-Z]|[0-9]("'")       {strncpy(yylval.pont->nome, yytext, 256);
                                return TK_CHAR;}

/*Identificador de variável*/

[a-zA-Z_][a-zA-Z0-9_]*          { strncpy(yylval.pont->nome, yytext, 256);
                                return TK_ID;}

/*Tipo booleano*/

("true"|"TRUE")                 {return TK_BOOL_TRUE;}
("false"|"FALSE")               {return TK_BOOL_FALSE;}

/*Identificadores de função - Ler / Escrever*/

("READ")                        {return TK_READ;}
("WRITE")                       {return TK_WRITE;}

/*Identificadores de função - Expressões Aritméticas*/

("ADD")                         {return TK_ADD;}
("SUB")                         {return TK_SUB;}
("MULT")                        {return TK_MULT;}
("DIV")                         {return TK_DIV;}
("MOD")                         {return TK_MOD;}

/*Identificadores de função - Comparações*/

("EQUAL"|"EQ")                  {return TK_EQ;}
("GREAT"|"GREATER")             {return TK_GREAT;}
("LESS"|"LESSER")               {return TK_LESS;}
("EQGREAT"|"GREATEQ")           {return TK_EQGREAT;}
("EQLESS"|"LESSEQ")             {return TK_EQLESS;}
("DIFF")                        {return TK_DIFF;}

/*Identificadores de função - Operações Lógicas*/

("AND")                         {return TK_AND;}
("OR")                          {return TK_OR;}
("XOR")                         {return TK_XOR;}
("NOT")                         {return TK_NOT;}

/*Identificadores de função - Desvios*/

("IF")                          {return TK_IF;}
("ELSEIF")                      {return TK_ELSEIF;}

/*Identificadores de função - Repetição*/

("LOOP")                        {return TK_LOOP;}

/*Blocos de Comando*/

("BEGIN")                       {return TK_BEGIN;}
("END")                         {return TK_END;}

/*Declaração de Ponteiro*/

("[")[a-zA-Z_][a-zA-Z0-9_]*("]")    {return TK_POINTER;}

/*Símbolos adicionais*/

(",")                           {return TK_SEPARADOR;}
("(")                           {return TK_ABREPARENTESES;}
(")")                           {return TK_FECHAPARENTESES;}

/*Palavras reservadas*/

("INT"|"FLOAT"|"CHAR")          {return TK_RESERVADA;}
("START")                       {return TK_START;}
("FINISH")                      {return TK_FINISH;}

.printf("Unknown token!\n"); yyterminate();

%%

int yywrap(void){
  return 1; 
}  
