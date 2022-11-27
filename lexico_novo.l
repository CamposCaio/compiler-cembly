%{
#include <string>
#include "parser.hpp"

#define SAVE_TOKEN  yylval.string = new std::string(yytext, yyleng)
#define TOKEN(t)    (yylval.token = t)
%}

%option noyywrap

%%

/*Tipos primitivos*/

[ \t\n]+                        SAVE_TOKEN; return TK_SPACE;
[0-9]                           SAVE_TOKEN; return TK_DIGITO;
[a-zA-Z]                        SAVE_TOKEN; return TK_LETRA;

/*Tipos de dado*/

("-")?[0-9]+                    SAVE_TOKEN; return TK_INT;
(("-")?[0-9]+)+\.([0-9]+)       SAVE_TOKEN; return TK_FLOAT;
("\'")[a-zA-Z]|[0-9]("\'")      SAVE_TOKEN; return TK_CHAR;

/*Identificador de variável*/

[a-zA-Z_][a-zA-Z0-9_]*          SAVE_TOKEN; return TK_ID;

/*Tipo booleano*/

("true"|"TRUE")                 SAVE_TOKEN; return TK_BOOL_TRUE;
("false"|"FALSE")               SAVE_TOKEN; return TK_BOOL_FALSE;

/*Identificadores de função - Expressões Aritméticas*/

("ADD")                         SAVE_TOKEN; return TK_ADD;
("SUB")                         SAVE_TOKEN; return TK_SUB;
("MULT")                        SAVE_TOKEN; return TK_MULT;
("DIV")                         SAVE_TOKEN; return TK_DIV;
("MOD")                         SAVE_TOKEN; return TK_MOD;

/*Identificadores de função - Comparações*/

("EQUAL"|"EQ")                  SAVE_TOKEN; return TK_EQ;
("GREAT"|"GREATER")             SAVE_TOKEN; return TK_GREAT;
("LESS"|"LESSER")               SAVE_TOKEN; return TK_LESS;
("EQGREAT"|"GREATEQ")           SAVE_TOKEN; return TK_EQGREAT;
("EQLESS"|"LESSEQ")             SAVE_TOKEN; return TK_EQLESS;
("DIFF")                        SAVE_TOKEN; return TK_DIFF;

/*Identificadores de função - Operações Lógicas*/

("AND")                         SAVE_TOKEN; return TK_AND;
("OR")                          SAVE_TOKEN; return TK_OR;
("XOR")                         SAVE_TOKEN; return TK_XOR;
("NOT")                         SAVE_TOKEN; return TK_NOT;

/*Identificadores de função - Desvios*/

("IF")                          SAVE_TOKEN; return TK_IF;
("ELSEIF")                      SAVE_TOKEN; return TK_ELSEIF;

/*Identificadores de função - Repetição*/

("LOOP")                        SAVE_TOKEN; return TK_LOOP;

/*Blocos de Comando*/

("BEGIN")                       SAVE_TOKEN; return TK_BEGIN;
("END")                         SAVE_TOKEN; return TK_END;

/*Declaração de Ponteiro*/

("[")[a-zA-Z_][a-zA-Z0-9_]*("]")    SAVE_TOKEN; return TK_POINTER;

/*Símbolos adicionais*/

(",")                           SAVE_TOKEN; return TK_SEPARADOR;
("(")                           SAVE_TOKEN; return TK_ABREPARENTESES;
(")")                           SAVE_TOKEN; return TK_FECHAPARENTESES;

/*Palavras reservadas*/

("INT"|"FLOAT"|"CHAR")          SAVE_TOKEN; return TK_RESERVADA;
("START")                       SAVE_TOKEN; return TK_START;
("FINISH")                      SAVE_TOKEN; return TK_FINISH;

.printf("Unknown token!\n"); yyterminate();

%%