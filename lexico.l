%{
#include <string>
#include <iostream>
%}
/*Tipos primitivos*/
TAB [\t]
DIGITO [0-9]
LETRA [a-zA-Z]
SPACE {TAB}+
/*Tipos de dado*/
INTEIRO ("-")?{DIGITO}+
FLOAT {INTEIRO}+(".")({DIGITO}+)
CARACTER \'({LETRA}|{DIGITO})\'
/*Identificador de variável*/
VARIAVEL {LETRA}({LETRA}|{DIGITO})*
/*Tipo booleano*/
BOOLEAN_TRUE ("true"|"TRUE")
BOOLEAN_FALSE ("false"|"FALSE")
/*Identificadores de função - Expressões Aritméticas*/
SOMA    ("ADD")
SUBTRACAO   ("SUB")
MULTIPLICACAO   ("MULT")
DIVISAO ("DIV")
RESTO   ("MOD")
/*Identificadores de função - Comparações*/
IGUAL   ("EQUAL"|"EQ")
MAIOR   ("GREAT"|"GREATER")
MENOR   ("LESS"|"LESSER")
MAIORIGUAL  ("EQGREAT"|"GREATEQ")
MENORIGUAL  ("EQLESS"|"LESSEQ")
DIFERENTE   ("DIFF")
/*Identificadores de função - Operações Lógicas*/
LOGICO_E ("AND")
LOGICO_OU ("OR")
LOGICO_XOR ("XOR")
LOGICO_NOT ("NOT")
/*Identificadores de função - Desvios*/
CONDICIONAL ("IF")
DESVIOCONDICIONAL ("ELSEIF")
/*Identificadores de função - Repetição*/
REPETICAO   ("LOOP")
/*Blocos de Comando*/
INICIOBLOCO ("BEGIN")
FIMBLOCO    ("END")
/*Declaração de Ponteiro*/
POINTER ("["){VARIAVEL}("]")
/*Símbolos adicionais*/
SEPARADOR   (",")
ABREPARENTESES ("(")
FECHAPARENTESES (")")
/*Palavras reservadas*/
RESERVADA   ("INT"|"FLOAT"|"CHAR")
/*Inválido*/
.{printf("%s é uma porção de código inválida.\n",yytext);}
%%

"\n"		{}

{SPACE} 	{}

"main"		{return TK_MAIN;}

"int"		{return TK_TIPO_INT;}

[(){}[\];,]	{ return *yytext; }

[+\-*/]		{ return *yytext; }

"="		    { return '='; }

{NUM}		{ yylval.label = yytext; return TK_NUM; }
{ID}		{ yylval.label = yytext; return TK_ID; }

.			{ *yytext; }

%%
