/*
 * Declarações
 */

%{
#include <iostream>
#include <string>
#include <sstream>
#include <vector>

#define YYSTYPE atributos

using namespace std;

int var_temp_qnt;

struct atributos
{
	string label;
	string traducao;
};

int yylex(void);
void yyerror(string);
string gentempcode();
%}

// Especificação de todos os tokens

%token TK_NUM
%token TK_MAIN TK_ID TK_TIPO_INT
%token TK_FIM TK_ERROR

%start S

%left '+'

/*
 * Regras de produção
 */

%%

/* -------------------- Início da Árvore -------------------- */

S 		: TK_START 'main' COMANDOS TK_FINISH 'main'
			{
				cout << 
					"#include <iostream> \
					\n#include<string.h> \
					\n#include<stdio.h> \
					\n#include<vector> \
					\nint main(void)\n{\n"
					<< $3.traducao << 
					"\treturn 0;\n}\n"; 
			}
			;

/* -------------------- Bloco -------------------- */

BLOCO		: TK_BEGIN COMANDOS TK_END
			{
				$$.traducao = $2.traducao;
			}
			;

/* -------------------- Comandos -------------------- */

COMANDOS	: COMANDO COMANDOS
			{
				$$.traducao = $1.traducao + $2.traducao;
			}
			|
			{
				$$.traducao = "";
			}
			;

/* -------------------- Comando -------------------- */

COMANDO 	: TK_ATRIB '(' E ')'
					| WRITE '(' E ')'
					| READ '(' E ')'

					| TK_IF '(' E ')'
					| TK_ELSEIF '(' E ')'
					| TK_LOOP '(' E ')'
					| EQUAL '(' E ')'
			;

/* -------------------- Expressões Aritiméticas -------------------- */

ARITMETICO 	: TK_ADD '(' E ')'
			;

/* -------------------- Expressões -------------------- */

E 		: TK_ID ',' TK_INT ',' TK_NUM_ARRAY
// <varName>, TK_INT, TK_NUM_ARRAY
			{
				$$.label = $1.label
				$$.traducao = "\t std::vector<int> " + $$.label + ";\n" + $5.traducao;
				// std::vector<int> t<n1>; + TK_NUM_ARRAY
			}

// <varName>, INT, <number>
			| TK_ID ',' TK_INT ',' TK_NUM
			{
				$$.label = $1.label
				$$.traducao = "\t int " + $$.label + " = " + $5.label + ";\n";
				// int t<n> = <number>;
			}

// <varName>, INT
			| TK_ID ',' TK_INT
			{
				$$.label = $1.label
				$$.traducao = "\t int " + $$.label + ";\n";
				// int t<n>;
			}

// <number>
			| TK_NUM
			{
				$$.label = gentempcode();
				$$.traducao = "\t" + $$.label + " = " + $1.label + ";\n";
				// t<new> = <number>
			}

// <varName>
			| TK_ID
			{
				$$.label = gentempcode();
				$$.traducao = "\t" + $$.label + " = " + $1.label + ";\n";
				// t<new> = <varName>;
			}
			;

/* -------------------- Array de números -------------------- */

TK_NUM_ARRAY 	: TK_NUM_ARRAY ',' TK_NUM_ARRAY
			{
				$$.label = $1.label;
				$$.traducao = "\t" + $$.label + ".pushback(" + $2.label + ");\n";
				// t<n1>.pushback(t<n2>);
			}

// <number>
			| TK_NUM
			{
				$$.label = gentempcode();
				$$.traducao = "\t" + $$.label + " = " + $1.label + ";\n";
				// t<new> = <number>;
			}
			;

/* -------------------- Fim da Árvore -------------------- */


%%

/*
 * Rotinas em C do usuário
 */

#include "lex.yy.c"

int yyparse();

string gentempcode()
{
	var_temp_qnt++;
	return "t" + std::to_string(var_temp_qnt);
}

int main(int argc, char* argv[])
{
	var_temp_qnt = 0;

	yyparse();

	return 0;
}

void yyerror(string MSG)
{
	cout << MSG << endl;
	exit (0);
}				
