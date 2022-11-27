%{
#include <string>
#include "parser.hpp"

string str = "";

void stringfile()
{
    fs::path p = fs::current_path();
    ofstream fout(p.relative_path());

    fout << str;

    fout.close();
}
%}

%option noyywrap

%%

/*Tipos primitivos*/

[ \t\n]+;
[0-9]                           {yylval.string = new std::string(yytext, yyleng); 
                                return TK_DIGITO;}
[a-zA-Z]                        {yylval.string = new std::string(yytext, yyleng);
                                return TK_LETRA;}

/*Tipos de dado*/

("-")?[0-9]+                    {yylval.string = new std::string(yytext, yyleng); 
                                return TK_INT;}
(("-")?[0-9]+)+\.([0-9]+)       {yylval.string = new std::string(yytext, yyleng); 
                                return TK_FLOAT;}
("\'")[a-zA-Z]|[0-9]("\'")      {yylval.string = new std::string(yytext, yyleng); 
                                return TK_CHAR;}

/*Identificador de variável*/

[a-zA-Z_][a-zA-Z0-9_]*          {yylval.string = new std::string(yytext, yyleng); 
                                return TK_ID;}

/*Tipo booleano*/

("true"|"TRUE")                 {yylval.string = new std::string(yytext, yyleng); 
                                return (yylval.token = TK_BOOL_TRUE);}
("false"|"FALSE")               {yylval.string = new std::string(yytext, yyleng); 
                                return (yylval.token = TK_BOOL_FALSE);}

/*Identificadores de função - Expressões Aritméticas*/

("ADD")                         {yylval.string = new std::string(yytext, yyleng); 
                                return (yylval.token = TK_ADD);}
("SUB")                         {yylval.string = new std::string(yytext, yyleng); 
                                return (yylval.token = TK_SUB);}
("MULT")                        {yylval.string = new std::string(yytext, yyleng); 
                                return (yylval.token = TK_MULT);}
("DIV")                         {yylval.string = new std::string(yytext, yyleng); 
                                return (yylval.token = TK_DIV);}
("MOD")                         {yylval.string = new std::string(yytext, yyleng); 
                                return (yylval.token = TK_MOD);}

/*Identificadores de função - Comparações*/

("EQUAL"|"EQ")                  {yylval.string = new std::string(yytext, yyleng); 
                                {return (yylval.token = TK_EQ);}
("GREAT"|"GREATER")             {yylval.string = new std::string(yytext, yyleng); 
                                {return (yylval.token = TK_GREAT);}
("LESS"|"LESSER")               {yylval.string = new std::string(yytext, yyleng); 
                                return (yylval.token = TK_LESS);}
("EQGREAT"|"GREATEQ")           {yylval.string = new std::string(yytext, yyleng); 
                                return (yylval.token = TK_EQGREAT);}
("EQLESS"|"LESSEQ")             {yylval.string = new std::string(yytext, yyleng); 
                                return (yylval.token = TK_EQLESS);}
("DIFF")                        {yylval.string = new std::string(yytext, yyleng); 
                                return (yylval.token = TK_DIFF);}

/*Identificadores de função - Operações Lógicas*/

("AND")                         {yylval.string = new std::string(yytext, yyleng); 
                                return (yylval.token = TK_AND);}
("OR")                          {yylval.string = new std::string(yytext, yyleng); 
                                return (yylval.token = TK_OR);}
("XOR")                         {yylval.string = new std::string(yytext, yyleng); 
                                return (yylval.token = TK_XOR);}
("NOT")                         {yylval.string = new std::string(yytext, yyleng); 
                                return (yylval.token = TK_NOT);}

/*Identificadores de função - Desvios*/

("IF")                          {yylval.string = new std::string(yytext, yyleng); 
                                return (yylval.token = TK_IF);}
("ELSEIF")                      {yylval.string = new std::string(yytext, yyleng); 
                                return (yylval.token = TK_ELSEIF);}

/*Identificadores de função - Repetição*/

("LOOP")                        {yylval.string = new std::string(yytext, yyleng); 
                                return (yylval.token = TK_LOOP);}

/*Blocos de Comando*/

("BEGIN")                       {yylval.string = new std::string(yytext, yyleng); 
                                return (yylval.token = TK_BEGIN);}
("END")                         {yylval.string = new std::string(yytext, yyleng); 
                                return (yylval.token = TK_END);}

/*Declaração de Ponteiro*/

("[")[a-zA-Z_][a-zA-Z0-9_]*("]")    {yylval.string = new std::string(yytext, yyleng); 
                                    return (yylval.token = TK_POINTER);}

/*Símbolos adicionais*/

(",")                           {yylval.string = new std::string(yytext, yyleng); 
                                return (yylval.token = TK_SEPARADOR);}
("(")                           {yylval.string = new std::string(yytext, yyleng); 
                                return (yylval.token = TK_ABREPARENTESES);}
(")")                           {yylval.string = new std::string(yytext, yyleng); 
                                return (yylval.token = TK_FECHAPARENTESES);}

/*Palavras reservadas*/

("INT"|"FLOAT"|"CHAR")          {yylval.string = new std::string(yytext, yyleng); 
                                return (yylval.token = TK_RESERVADA);}
("START")                       {yylval.string = new std::string(yytext, yyleng); 
                                return (yylval.token = TK_START);}
("FINISH")                      {yylval.string = new std::string(yytext, yyleng); 
                                return (yylval.token = TK_FINISH);}

.                               {printf("Unknown token!\n"); 
                                yyterminate();}

%%