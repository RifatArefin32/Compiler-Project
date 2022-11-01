%{
	
	#include<stdio.h>
	#include<string.h>
	#include<stdlib.h>
	
%}


ID					[a-z][_a-zA-Z0-9]*
HEADER				"using"[ ]*[a-z]+.[h]
NUM					[-]?[0-9][0-9]*[.]?[0-9]*
BINARY_OPERATOR 	"+"|"/"|"-"|"*"|"%"
TYPES				"Int"|"Float"|"String"|"Char"

%%

[ \t]+

[/][#]			{
					char c, d;
					lab:
					while(1){
						c = input();
						if(c =='#'){
								break;
						}
					}
					d = input();
					if(d=='/'){
						printf("This is multiple line comment\n");
					}
					else{
						goto lab;
					}
				}
[#].* 			printf("This is single line comment\n");


"Start"[ ]*[:][ ]* 		printf("start() found\n");
"Int"			printf("INT found\n");
"Char"			printf("CHAR found\n");
"Float"			printf("FLOAT found\n");
"String"		printf("STRING found\n");

"Max"[ ]*['('][ ]*({ID}|{NUM})[ ]*[,][ ]*({ID}|{NUM})[ ]*[')'][ ]*			printf("MAX found\n");
"Min"[ ]*['('][ ]*({ID}|{NUM})[ ]*[,][ ]*({ID}|{NUM})[ ]*[')'][ ]*			printf("MIN found\n");
"Pow"[ ]*['('][ ]*({ID}|{NUM})[ ]*[,][ ]*({ID}|{NUM})[ ]*[')'][ ]*			printf("POWER found\n");
"Facto"[ ]*['('][ ]*({ID}|{NUM})[ ]*[')'][ ]*								printf("FACTORIAL found\n");


"Read"[ ]*['('][ ]*({ID})[ ]*[')'][ ]*			printf("READ found\n");
"Print"[ ]*['('][ ]*({ID})[ ]*[')'][ ]*			printf("PRINT found\n");

"Switch"[ ]*['('][ ]*({ID})[ ]*[')'][ ]*[:][ ]*		printf("SWITCH found\n");
"Complementary"										printf("DEFAULT found\n");

"If"[ ]+{ID}[ ]*("=="|"<"|">"|"<="|">="|"!=")[ ]*({NUM}|{ID})[ ]*	{
	char c;
	while(1){
		if(input()=='F'){
			if(input()=='i'){
				printf("If found\n");
				break;
			}
		}
	}
}		

"Elif"[ ]+{ID}[ ]*("=="|"<"|">"|"<="|">="|"!=")[ ]*({NUM}|{ID})[ ]*	{
	char c;
	while(1){
		if(input()=='F'){
			if(input()=='e'){
				printf("Else If found\n");
				break;
			}
		}
	}
}

"Otherwise"	{
	char c;
	while(1){
		if(input()=='E'){
			if(input()=='o'){
				printf("Otherwise found\n");
				break;
			}
		}
	}
}

"For"[ ]*{ID}[ ]+"from"[ ]+({NUM}|{ID})[ ]+"to"[ ]+({NUM}|{ID})[ ]* {
	char c;
	while(1){
		if(input()=='F'){
			if(input()=='E'){
				printf("For loop found\n");
				break;
			}
		}
	}
}

"While"[ ]+{ID}[ ]*("=="|"<"|">"|"<="|">="|"!=")[ ]*({NUM}|{ID})[ ]*	{
	char c;
	while(1){
		if(input()=='W'){
			if(input()=='E'){
				printf("While loop found\n");
				break;
			}
		}
	}
}			

"Inc"[ ]+{ID}[ ]*			printf("INC found\n");
"Dec"[ ]+{ID}[ ]*			printf("DEC found\n");

{ID}[ ]*"="[ ]*({ID}|{NUM})												printf("Assignment found\n");
{ID}[ ]*"="[ ]*({ID}|{NUM})[ ]*{BINARY_OPERATOR}[ ]*({ID}|{NUM})[ ]* 	printf("Binary Operation : %s\n",yytext);

"Fun"[ ]+{ID}[ ]*['('][ ]*({ID}[,][ ]*)*({ID}[ ]*)?[')'][ ]*":"[ ]*{TYPES}[ ]* 	{
    char c;
	while(1){
		if(input()=='N'){
			if(input()=='f'){
				printf("User defined Function found\n");
				break;
			}
		}
	}
}


"Sine"[ ]*['('][ ]*({ID}|{NUM})[ ]*[')'][ ]*			printf("SIN found\n");
"Cosine"[ ]*['('][ ]*({ID}|{NUM})[ ]*[')'][ ]*		printf("COS found\n");
"Tangent"[ ]*['('][ ]*({ID}|{NUM})[ ]*[')'][ ]*		printf("TAN found\n");
"Ln"[ ]*['('][ ]*({ID}|{NUM})[ ]*[')'][ ]*			printf("LN found\n");
"Log10"[ ]*['('][ ]*({ID}|{NUM})[ ]*[')'][ ]*			printf("LOG10 found\n");
"Log2"[ ]*['('][ ]*({ID}|{NUM})[ ]*[')'][ ]*			printf("LOG2 found\n");




[\n]	{}

%% 

int yywrap()
{
	return 1;
}


int main(){
    yyin = freopen("input.txt","r",stdin);
    yyout = freopen("output.txt","w",stdout);
    yylex();
}
