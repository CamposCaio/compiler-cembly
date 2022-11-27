# Cembly compiler C++ and Assembly

### Como construir o projeto?
Execute os seguintes comandos no terminal:

    make clean
    make

### Como utilizar o compilador?
Após construir o projeto, um arquivo `cembly` executável foi gerado. Execute o comando a seguir apontando para o seu arquivo escrito em cembly (você pode utilizar um dos exemplos disponibilizados).

    ./cembly <CAMINHO_PARA_CÓDIGO_CEMBLY>

Exemplo:

    ./cembly example1.cembly

Um novo arquivo `.cc` será gerado com o nome do seu código.

### Como rodar o arquivo C++?

    g++ <CÓDIGO_C++_GERADO> -o <NOME_ARQUIVO_COMPILADO>

Exemplo:

    g++ example1.cembly.cc -o example1

Agora você já pode executar o arquivo:

    ./example1