#ifndef _MEUCOMPILADOR_H_
#define _MEUCOMPILADOR_H_

struct No {
  int token;
  double val;
  char nome[256];

  struct No *esq, *dir, *lookahead, *lookahead1, *lookahead2, *lookahead3;
};

typedef struct No No;

#endif
