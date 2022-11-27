/* Estrutura para armazenar nomes de variaveis */

#ifndef _ESTRUTURA_VAR_H_
#define _ESTRUTURA_VAR_H_

struct Lista_var{
  char var[32];

  struct Lista_var *prox;
};

typedef struct Lista_var Lista_var;

Lista_var *prim, *ant, *aux;

extern void cria_lista();
extern int insere_var(char *var);

#endif
