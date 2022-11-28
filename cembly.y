%{
#include<stdio.h>
#include<math.h> 
#include<stdlib.h>
#include<string.h>
#include <cstdio>
#include <iostream>
using namespace std;

#include "estrutura_var.c"

#include"cembly.h"
#include "estrutura_var.h"




#define YYERROR_VERBOSE

extern "C" int yylex();
extern "C" int yyparse();
extern "C" FILE *yyin;

void yyerror(const char *s);
void imprima(No *raiz);
void imprimaLog(No *raiz);

FILE *entrada, *saida, *saidaLog;

No *raiz, *raizLog;
char *var_nome;   

%}

%union{
  No *pont;
}

/*Terminais*/
%token <pont> FOR 	/*para*/
%token <pont> WHILE /*enquanto*/
%token <pont> IF 	/*se*/
%token <pont> ELSE 	/*seNao*/
%token <pont> WRITE/*imprime*/ 
%token <pont> READ_INT /*le inteiro*/ 
%token <pont> READ_FLOAT /*le FLOAT*/ 
%token <pont> READ_CHAR /*le char*/ 
%token <pont> NUM 	/*numeros*/
%token <pont> LETRA	/*strings*/
%token <pont> COMANDO /*comando*/
%token <pont> MEI	/*<=*/
%token <pont> MI	/*>=*/
%token <pont> II	/*==*/
%token <pont> TI	/*!=*/
%token <pont> MA	/*<*/
%token <pont> ME	/*>*/
%token <pont> INT	/*inteiro*/
%token <pont> FLOAT/*FLOAT*/
%token <pont> CHAR  /*char*/
%token <pont> TK_ID
%token <pont> TK_BEGIN	/*inicio do bloco*/
%token <pont> TK_END	/*fim do bloco*/
%token <pont> TK_START	/*inicio do programa*/
%token <pont> TK_FINISH	/*fim do programa*/

/*Não Terminais*/
%type <pont> programa
%type <pont> lista_comandos
%type <pont> bloco
%type <pont> string
%type <pont> tipo_numerico
%type <pont> atribuicao
%type <pont> exp
%type <pont> comando
%type <pont> comparacao
%type <pont> diferente
%type <pont> igual
%type <pont> menor
%type <pont> maior
%type <pont> menor_igual
%type <pont> maior_igual
%type <pont> if_comando
%type <pont> write_comando
%type <pont> read_comando
%type <pont> while_comando
%type <pont> for_comando
%type <pont> tipo_char
%type <pont> tipo_id
%type <pont> tipo_qualquer

%right '='
%left  '-' '+'

%%

/* Bloco Programa */
/*Inicia a arvore de Tokens*/
programa: 
      TK_START lista_comandos TK_FINISH
			{ 
			  raiz = $2; 
			} 
;



/* Bloco Lista De comandos */
/* Guarda um comando ou uma lista deles*/
lista_comandos: 
      comando ';' 
			{ 
			  $$ = (No*)malloc(sizeof(No)); 
			  $1->lookahead = 0;				
			  $$ = $1; 
			}
|     comando ';' lista_comandos 
			{ 
			  $$ = (No*)malloc(sizeof(No));
			  $1->lookahead = $3;
			  $$ = $1;
			}
;
/* Bloco bloco */
/* Abre os comandos*/
bloco: 
      TK_BEGIN lista_comandos TK_END 
			{ 
			  $$ = $2; 
			} 
;
/* Bloco String */
/* Reconhece Strings */
string:
      LETRA       
			{ 
			  $$ = (No*)malloc(sizeof(No));
        $$->token = LETRA;
		    strcpy($$->nome, yylval.pont->nome);
		    $$->esq = NULL;
		    $$->dir = NULL;
      }
;

/* Bloco ID */
/* Reconhece qualquer variavel (letra seguida de letras ou numeros) */
tipo_id: 
      TK_ID
			{ 
			  $$ = (No*)malloc(sizeof(No));
        $$->token = TK_ID;
        strcpy($$->nome, yylval.pont->nome);
        $$->esq = NULL;
		    $$->dir = NULL;
			}
|	    string
;

/* Bloco Tipo Basico */
/* Reconhece os Tipos Basicos Numericos*/
tipo_numerico: 
      INT
			{ 
			  $$ = (No*)malloc(sizeof(No));
        $$->token = INT;
		    strcpy($$->nome, yylval.pont->nome);//Vai guardar inteiro nesta val
		    $$->esq = NULL;
		    $$->dir = NULL;
      }
|     FLOAT
			{ 
			  $$ = (No*)malloc(sizeof(No));
        $$->token = FLOAT;
		    strcpy($$->nome, yylval.pont->nome);//Vai guardar FLOAT nesta val
		    $$->esq = NULL;
		    $$->dir = NULL;
      }
;	   

/* Bloco Tipo Basico */
/* Reconhece o Tipo Char*/
tipo_char:
      CHAR
			{ 
			  $$ = (No*)malloc(sizeof(No));
        $$->token = CHAR;
		    strcpy($$->nome, yylval.pont->nome);//Vai guardar char nesta val
		    $$->esq = NULL;
		    $$->dir = NULL;
      }
;
/* Bloco Tipo Qualquer */
/* Reconhece os tipos anteriores */
tipo_qualquer:
      tipo_char
      {
      $$ = (No*)malloc(sizeof(No));
      $$->token = TK_ID;
      $$ = $1;
      }
|     tipo_numerico
      {
      $$ = (No*)malloc(sizeof(No));
      $$->token = TK_ID;
      $$ = $1;
      }
|     string
      {
      $$ = (No*)malloc(sizeof(No));
      $$->token = TK_ID;
      $$ = $1;
      }
;

/* Bloco Atribuicao */
/* Bloco para reconhecer atribuicao e declaracao de variaveis*/
atribuicao: 
    tipo_numerico tipo_id '=' exp //reconhece atribuições, tipo numerico, onde primeiro é definido uma variavel 
		{ 				//e logo em seguida ja é atribuido um valor
		  $$ = (No*)malloc(sizeof(No));
		  $$->token = '=';				
		  $$->esq = $2;									
		  $$->lookahead2 = $1;					 
		  $$->dir = $4;				
		  $$->lookahead3 = NULL;				
    }
|   tipo_char tipo_id '=' '\'' exp '\''//reconhece atribuições, tipo character, onde primeiro é definido 
		{				    //uma variavel e logo em seguida ja é atribuido um valor
		  $$ = (No*)malloc(sizeof(No)); 
		  $$->token = '=';
		  $$->esq = $2;
		  $$->lookahead2 = $1;
		  $$->lookahead3 = $1;
		  $$->dir = $5;
    }
|   tipo_numerico tipo_id ';' //reconhece atribuições onde apenas é declarada a variavel, tipo numerico
		{ 
			$$ = (No*)malloc(sizeof(No));
			$$->token = ';';
			$$->esq = $1;
			$$->dir = $2;
    }
		tipo_char tipo_id';' //reconhece atribuições onde apenas é declarada a variavel, tipo character
		{ 
		  $$ = (No*)malloc(sizeof(No));
		  $$->token = ';';
		  $$->esq = $1;
		  $$->dir = $2;
    }
|   tipo_id '=' '\'' exp '\'' //reconhece atribuições, onde ja foi declarada a variavel, apenas character
		{ 
			$$ = (No*)malloc(sizeof(No));
			$$->token = '=';
			$$->esq = $1;
			$$->dir = $4;
			$$->lookahead3 = $1;
    }
|   tipo_id '=' exp //reconhece atribuições, onde ja foi declarada a variavel, apenas numeros
		{ 
			$$ = (No*)malloc(sizeof(No));
			$$->token = '=';
			$$->esq = $1;
			$$->dir = $3;
			$$->lookahead2 = NULL;
			$$->lookahead3 = NULL;
    }
;
/* Bloco exp */
/* Bloco com as expressões numericas e as strings */
exp:   
    tipo_id	//string
|   NUM       	//numeros   
		{ 
			$$ = (No*)malloc(sizeof(No));
      $$->token = NUM;
		  $$->val = yylval.pont->val;
		  $$->esq = NULL;
		  $$->esq = NULL;
    }            
|   '-' NUM      	//numeros negativos
		{ 
			$$ = (No*)malloc(sizeof(No));
      $$->token = NUM;
		  $$->val = - yylval.pont->val;
		  $$->esq = NULL;
		  $$->esq = NULL;
    }
|   exp '+' exp   //reconhece somas
		{ 
			$$ = (No*)malloc(sizeof(No));
      $$->token = '+';
		  $$->esq = $1;
		  $$->dir = $3;
    }
|   exp '-' exp   //reconhece subtrações	  
		{ 
			$$ = (No*)malloc(sizeof(No));
      $$->token = '-';
		  $$->esq = $1;
		  $$->dir = $3;
    }
|   '(' exp ')' 	   //Possibilita o reconhecimento de uma exp que esteja entre parentese
		{ 
			$$ = (No*)malloc(sizeof(No));
      $$ = $2;
    }
;
						
/* Bloco comando */ 
/* Bloco com os varios comandos na linguagem */ 
comando:  
    atribuicao
|   bloco
|   while_comando
|	  for_comando
|	  if_comando
|	  write_comando
|	  read_comando
;

/* Bloco Comparacao */
/* Bloco com as comparacoes logicas */
comparacao: 
    igual
|    maior
|    menor
|	  maior_igual
|    menor_igual
|	  diferente
;


/* Bloco Diferente */
/* Bloco com a regra "diferente de"*/
diferente: 
    exp TI exp     
		{
			$$ = (No*)malloc(sizeof(No));
      $$->token = TI;
			$$->esq = $1;
			$$->dir = $3;
			$$->lookahead1 = NULL;
    }
;
/* Bloco Igual */
/* Bloco com a regra "igual a"*/
igual: 
    exp II exp     
		{
			$$ = (No*)malloc(sizeof(No));
      $$->token = II;
			$$->esq = $1;
			$$->dir = $3;
			$$->lookahead1 = NULL;
    }
;
/* Bloco Menor*/
/* Bloco com a regra "menor que"*/
menor: 
    exp ME exp     
		{
			$$ = (No*)malloc(sizeof(No));
      $$->token = ME;
			$$->esq = $1;
			$$->dir = $3;
			$$->lookahead1 = NULL;
    }
;
/* Bloco Maior*/
/* Bloco com a regra "maior que"*/
maior: 
    exp MA exp     
		{
			$$ = (No*)malloc(sizeof(No));
      $$->token = MA;
			$$->esq = $1;
			$$->dir = $3;
			$$->lookahead1 = NULL;
    }
;
/* Bloco Menor Ou Igual*/
/* Bloco com a regra "menor ou igual a"*/
menor_igual: 
    exp MEI exp     
		{
			$$ = (No*)malloc(sizeof(No));
      $$->token = MEI;
			$$->esq = $1;
			$$->dir = $3;
			$$->lookahead1 = NULL;
    }
;
/* Bloco Maior Ou Igual*/
/* Bloco com a regra "maior ou igual a"*/
maior_igual: 
    exp MI exp     
		{
			$$ = (No*)malloc(sizeof(No));
      $$->token = MI;
			$$->esq = $1;
			$$->dir = $3;
			$$->lookahead1 = NULL;
    }
;

/* comando Se  */
/* Bloco com a regra para definir o eveto IF*/
if_comando:  
    IF '(' comparacao ')' bloco	//IF com apenas comparações
    { 
      $$ = (No*)malloc(sizeof(No));
		  $$->token = IF;
		  $$->lookahead1 = $3;
		  $$->esq = $5;
		  $$->dir = NULL;
    }
    IF '(' comparacao ')' bloco ELSE bloco  //IF e ELSE com apenas comparações
    { 
      $$ = (No*)malloc(sizeof(No));
		  $$->token = IF;
		  $$->lookahead1 = $3;
		  $$->esq = $5;
		  $$->dir = $7;
    }
;
/* comando Imprimir */
/* Bloco com a regra para definir o eveto printf*/
write_comando: 
    WRITE '('  tipo_id  ')'		//imprime na tela apenas strings
		{
		 $$ = (No*)malloc(sizeof(No));
		 $$->token = WRITE; 
		 $$->esq = $3;
		 $$->dir = NULL;
		}
	  WRITE '('  tipo_id ',' tipo_numerico tipo_id ')' 	//imprime na tela strings e mais uma variavel numerica
		{
		 $$ = (No*)malloc(sizeof(No));
		 $$->token = WRITE; 
		 $$->esq = $3;
		 $$->dir = $5;
		 $$->lookahead1 = $6;
		}
	  WRITE '('  tipo_id ',' tipo_char tipo_id ')'		//imprime na tela strings e mais uma variavel do tipo char
		{
		 $$ = (No*)malloc(sizeof(No));
		 $$->token = WRITE; 
		 $$->esq = $3;
		 $$->dir = $5;
		 $$->lookahead1 = $6;
		}
;
/* comando Read */
/* Bloco com a regra para definir o eveto scanf para int*/
read_comando: 
    READ_INT '(' tipo_id  ')'		//Le do teclado um inteiro
		{
		 $$ = (No*)malloc(sizeof(No));
		 $$->token = READ_INT; 
		 $$->esq = $3;
		 $$->dir = NULL;
		}
	READ_FLOAT '(' tipo_id  ')'		//Le do teclado um FLOAT
		{
		 $$ = (No*)malloc(sizeof(No));
		 $$->token = READ_FLOAT; 
		 $$->esq = $3;
		 $$->dir = NULL;
		}
	READ_CHAR '(' tipo_id  ')'		//Le do teclado um FLOAT
		{
		 $$ = (No*)malloc(sizeof(No));
		 $$->token = READ_CHAR; 
		 $$->esq = $3;
		 $$->dir = NULL;
		}
;

/* comando Para */
/* Bloco com a regra para definir o eveto FOR*/
for_comando: 
      FOR '(' atribuicao ';' comparacao ')' bloco	//possibilita comando FOR com regras com apenas numeros ou com variaveis
		  {
		   $$ = (No*)malloc(sizeof(No));
		   $$->token = FOR;
		   $$->lookahead1 = $3;
		   $$->lookahead2 = $5;
		   $$->esq = $7;
		   $$->dir = NULL;
		  }
;

/* comando Enquanto */
while_comando: 
            WHILE '(' comparacao ')' bloco 	//possibilita comando WHILE
            {
              $$ = (No*)malloc(sizeof(No));
              $$->token = WHILE;
              $$->lookahead1 = $3;
              $$->esq = $5;
              $$->dir = NULL;
            }
;


%%

int main(int argc, char *argv[])
{
  char buffer[256];

  extern FILE *yyin;

  yylval.pont = (No*)malloc(sizeof(No));

  if (argc < 2){
    printf("Ops! Voce fez alguma coisa errada!\n");
    exit(1);
  }
  
  entrada = fopen(argv[1],"r");
  if(!entrada){
    printf("Erro! O arquivo de entrada nao pode ser aberto ! \n");
    exit(1);
  }

  yyin = entrada;

  strcpy(buffer,argv[1]);
  strcat(buffer,".cc");
  
  saida = fopen(buffer,"w");
  if(!saida){
    printf("Erro!!!!!\n O arquivo saida nao pode ser criado ou aberto! \n");
    exit(1);
  }

  saidaLog = fopen("saidaLog.txt","a");
  if(!saidaLog){
    printf("Erro!!!!!\n O arquivo saidaLog nao pode ser criado ou aberto! \n");
    exit(1);
  }

  yyparse();

  fprintf(saida,"#include<string.h>\n");
  fprintf(saida,"#include<stdio.h>\n");
  fprintf(saida,"#include<math.h>\n");	
  fprintf(saida,"\nint main(int argc, char *argv[]){\n");
  cria_lista();
  raizLog = raiz;
  imprimaLog(raizLog);
  imprima(raiz);
  fprintf(saida,"\nreturn 0;\n");
  fprintf(saida,"\n}\n");

  fclose(entrada);
  fclose(saida);
  fclose(saidaLog);
}


void yyerror(const char *s) {
  printf("%s\n", s);
}

void imprimaLog(No *raiz){
  if (raiz != NULL){
  fprintf(saidaLog,"Token = %d (%c) \n", raiz->token, raiz->token);
    if (raiz->lookahead != NULL) {
      imprimaLog(raiz->lookahead);
    }
}
}


void imprima(No *raiz){

  if (raiz != NULL){
    switch(raiz->token){
    case NUM:
      fprintf(saida,"%g", raiz->val);
      break;

    case LETRA:
      fprintf(saida,"%s ", raiz->nome);
      break;

   case INT:
      fprintf(saida,"int ");
      break;

   case FLOAT:
      fprintf(saida,"float ");
      break;

   case CHAR:
      fprintf(saida,"char ");
      break;

    case '=':
    if(raiz->lookahead2==NULL){
      imprima(raiz->esq);
      fprintf(saida,"=");
      imprima(raiz->dir);
      fprintf(saida,";");
      break;    
    }
    else {
      if(raiz->lookahead3==NULL){
          imprima(raiz->lookahead2);
          imprima(raiz->esq);
          fprintf(saida,"=");
          imprima(raiz->dir);
          fprintf(saida,";\n");
          break;  
      }else{
      imprima(raiz->lookahead2);
      imprima(raiz->esq);
      fprintf(saida,"=");
      fprintf(saida," '");
      imprima(raiz->dir);
      fprintf(saida,"' ");
      fprintf(saida,";\n");
      break;
      }  
    }
      
    case ';':
      imprima(raiz->esq);
      fprintf(saida," ");
      imprima(raiz->dir);
      fprintf(saida,";\n");
      break;

    case '+':
      imprima(raiz->esq);
      fprintf(saida,"+");
      imprima(raiz->dir);
      break;

    case '-':
      imprima(raiz->esq);
      fprintf(saida,"-");
      imprima(raiz->dir);
      break;

    case '*':
      imprima(raiz->esq);
      fprintf(saida,"*");
      imprima(raiz->dir);
      break;
      
    case '/':
      imprima(raiz->esq);
      fprintf(saida,"/");
      imprima(raiz->dir);
      break;

    case '%':
      fprintf(saida,"int(");
      imprima(raiz->esq);
      fprintf(saida,")");
      fprintf(saida,"%%");
      fprintf(saida,"int(");
      imprima(raiz->dir);
      fprintf(saida,")");
      break;

    case ',':
      imprima(raiz->esq);
      fprintf(saida,",");
      imprima(raiz->dir);
      break;

    case II:
      if(raiz->lookahead1==NULL){
	imprima(raiz->esq);
        fprintf(saida,"==");
        imprima(raiz->dir);
        break;
      }else{
	imprima(raiz->esq);
        fprintf(saida,"==");
        imprima(raiz->dir);
	imprima(raiz->lookahead1);
	fprintf(saida,"(");
	imprima(raiz->lookahead2);
	fprintf(saida,")");
        break;
	}
    case TI:
      if(raiz->lookahead1==NULL){
	imprima(raiz->esq);
        fprintf(saida,"!=");
        imprima(raiz->dir);
        break;
      }else{
	imprima(raiz->esq);
        fprintf(saida,"!=");
        imprima(raiz->dir);
	imprima(raiz->lookahead1);
	fprintf(saida,"(");
	imprima(raiz->lookahead2);
	fprintf(saida,")");
        break;
      }
      
    case MA:
      if(raiz->lookahead1==NULL){
	imprima(raiz->esq);
        fprintf(saida,">");
        imprima(raiz->dir);
        break;
      }else{
	imprima(raiz->esq);
        fprintf(saida,">");
        imprima(raiz->dir);
	imprima(raiz->lookahead1);
	fprintf(saida,"(");
	imprima(raiz->lookahead2);
	fprintf(saida,")");
        break;
	}
    case ME:
      if(raiz->lookahead1==NULL){
	imprima(raiz->esq);
        fprintf(saida,"<");
        imprima(raiz->dir);
        break;
      }else{
	imprima(raiz->esq);
        fprintf(saida,"<");
        imprima(raiz->dir);
	imprima(raiz->lookahead1);
	fprintf(saida,"(");
	imprima(raiz->lookahead2);
	fprintf(saida,")");
        break;
	}

    case MI:
      if(raiz->lookahead1==NULL){
	imprima(raiz->esq);
        fprintf(saida,">=");
        imprima(raiz->dir);
        break;
      }else{
	imprima(raiz->esq);
        fprintf(saida,">=");
        imprima(raiz->dir);
	imprima(raiz->lookahead1);
	fprintf(saida,"(");
	imprima(raiz->lookahead2);
	fprintf(saida,")");
        break;
	}
    case MEI:
      if(raiz->lookahead1==NULL){
	imprima(raiz->esq);
        fprintf(saida,"<=");
        imprima(raiz->dir);
        break;
      }else{
	imprima(raiz->esq);
        fprintf(saida,"<=");
        imprima(raiz->dir);
	imprima(raiz->lookahead1);
	fprintf(saida,"(");
	imprima(raiz->lookahead2);
	fprintf(saida,")");
        break;
	}
    case COMANDO:
      imprima(raiz->lookahead1);
      fprintf(saida,"(");
      imprima(raiz->esq);
      fprintf(saida,")");
      fprintf(saida,";\n");
      break;

    case '.':
      imprima(raiz->esq);
      fprintf(saida," ");
      imprima(raiz->dir);
      fprintf(saida," ");
      break;
      
    case IF:
      fprintf(saida," \nif ");
      fprintf(saida,"(");
      imprima(raiz->lookahead1);
      fprintf(saida,")");
      fprintf(saida," {\n");
      imprima(raiz->esq);
      fprintf(saida,"\n}");
      
      if(raiz->dir != NULL){
	fprintf(saida,"\n else");
	fprintf(saida," {\n");
	imprima(raiz->dir);
	fprintf(saida," }\n");
      }
      else fprintf(saida,"\n");
      break;
      
    case WHILE:
      fprintf(saida," \nwhile ");
      fprintf(saida,"(");
      imprima(raiz->lookahead1);
      fprintf(saida,")");
      fprintf(saida," {\n");
      imprima(raiz->esq);
      fprintf(saida," }");
      break;
 
    case FOR:
      fprintf(saida," \n for");
      fprintf(saida,"(");
      imprima(raiz->lookahead1);
      imprima(raiz->lookahead2);
      fprintf(saida,"; ");
      imprima(raiz->lookahead1->esq);
      fprintf(saida,"++");
      fprintf(saida,")");
      fprintf(saida," {\n");
      imprima(raiz->esq);
      fprintf(saida,"\n } \n");
      break;

case READ_INT:
      fprintf(saida," \n scanf");
      fprintf(saida,"(");
      fprintf(saida,"\"");
      fprintf(saida,"%%d");
      fprintf(saida,"\"");
      fprintf(saida,",");
      fprintf(saida,"&");
      imprima(raiz->esq);
      fprintf(saida,")");
      fprintf(saida,"; ");
      fprintf(saida,"\n");
      break;

case READ_CHAR:
      fprintf(saida," \n scanf");
      fprintf(saida,"(");
      fprintf(saida,"\"");
      fprintf(saida,"%%c");
      fprintf(saida,"\"");
      fprintf(saida,",");
      fprintf(saida,"&");
      imprima(raiz->esq);
      fprintf(saida,")");
      fprintf(saida,"; ");
      fprintf(saida,"\n");
      break;

case READ_FLOAT:
      fprintf(saida," \n scanf");
      fprintf(saida,"(");
      fprintf(saida,"\"");
      fprintf(saida,"%%e");
      fprintf(saida,"\"");
      fprintf(saida,",");
      fprintf(saida,"&");
      imprima(raiz->esq);
      fprintf(saida,")");
      fprintf(saida,"; ");
      fprintf(saida,"\n");
      break;

case WRITE:
    if(raiz->dir==NULL){
      fprintf(saida," \n printf");
      fprintf(saida,"(");
      fprintf(saida,"\"");
      imprima(raiz->esq);
      fprintf(saida,"\"");
      fprintf(saida,")");
      fprintf(saida,"; ");
      fprintf(saida,"\n");
      break;
	}
      else{
	fprintf(saida," \n printf");
        fprintf(saida,"(");
        fprintf(saida,"\"");
	imprima(raiz->esq);
	fprintf(saida," ");

	if(raiz->dir->token== INT){
	fprintf(saida,"%%d");        
        fprintf(saida,"\"");
	fprintf(saida,",");
	imprima(raiz->lookahead1);
        fprintf(saida,")");
        fprintf(saida,"; ");
        fprintf(saida,"\n");
	break;
	}else if (raiz->dir->token== FLOAT){
	fprintf(saida,"%%f");        
        fprintf(saida,"\"");
	fprintf(saida,",");
	imprima(raiz->lookahead1);
        fprintf(saida,")");
        fprintf(saida,"; ");
        fprintf(saida,"\n");
	break;
	}else if (raiz->dir->token== CHAR){
	fprintf(saida,"%%c");        
        fprintf(saida,"\"");
	fprintf(saida,",");
	imprima(raiz->lookahead1);
        fprintf(saida,")");
        fprintf(saida,"; ");
        fprintf(saida,"\n");
	break;
	}else{
	fprintf(saida,"%%d");       
        fprintf(saida,"\"");
	fprintf(saida,",");
	imprima(raiz->lookahead1);
        fprintf(saida,")");
        fprintf(saida,"; ");
        fprintf(saida,"\n");
	break;
	}
	}

   default: 
      fprintf(saida,"Desconhecido: Token = %d (%c) \n", raiz->token, raiz->token);
    }
    if (raiz->lookahead != NULL) {
      imprima(raiz->lookahead);
    }
  }
}