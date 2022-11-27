all: 	
	clear
	bison -d cembly.y
	flex cembly.l
	g++ cembly.tab.c lex.yy.c -o main -lm

clean:
	rm cembly.tab.c
	rm cembly.tab.h
	rm lex.yy.c
