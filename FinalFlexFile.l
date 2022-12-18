%{
	// Adding all the neccessary header file and function definations
	#include<stdio.h>
	#include<string.h>
	#include<stdlib.h>
	#include "bisonFile.tab.h"

%}



ID					[a-z][_a-zA-Z0-9]*
HEADER				"using"[ ]+[a-z]+.[h]
NUM					[-]?[0-9][0-9]*[.]?[0-9]*
STR	              	["][^"]*["]
CHR 				['][a-zA-z][']

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
						printf("\nMultiple line comment detected\n");
					}
					else{
						goto lab;
					}
				}
[#].* 			printf("\nSingle line comment detected\n");


"Start"[ ]*[:][ ]* 		return(MAIN);
"Int"					return(INT);
"Char"					return(CHAR);
"Float"					return(FLOAT);
"String"				return(STRING);
"Void"					return(VOID);
"Max"					return(MAX);
"Min"					return(MIN);
"Pow"					return(POW);
"Facto"					return(FACTO);
"CheckPrime"			return(PRIME);

"Read"					return(READ);
"Print"					return(PRINT);
"Switch"				return(SWITCH);
"Case"					return(CASE);
"Complementary"			return(DEFAULT);

"If"					return(IF);
"Elif"					return(ELIF);
"Otherwise"				return(ELSE);
"From"					return(FROM);
"To"					return(TO);
"While"					return(WHILE);
"Inc"					return(INC);
"Dec"					return(DEC);

"Fun"					return(FUN);

"="		return(ASSIGN);
"+"		return(PLUS);
"-"		return(MINUS);
"*"		return(MUL);
"/"		return(DIV);
"=="	return(EQUAL);
"!="	return(NOTEQUAL);
">"		return(GT);
">="	return(GTE);
"<"		return(LT);
"<="	return(LTE);

"Sine" 		return(SIN);
"Cosine"	return(COS);
"Tangent"	return(TAN);
"Ln"		return(LN);
"Log10"		return(LOG10);
"Log2"		return(LOG2);


{HEADER}	printf("Header file detected.\n");

{ID}		{
				//printf("namee : %s\n",yytext);
				yylval.stringValue = strdup(yytext); 
				return(ID);
			}

{STR} 	{
	yylval.stringValue = strdup(yytext);
	return STR;
}

{CHR} {
	yylval.stringValue = strdup(yytext);
	return CHR;
}


{NUM}		{	int length = strlen(yytext);
				int i = 0;
				while(i<length){
					if(yytext[i]=='.'){
						yylval.val = atof(yytext); 
						return(NUM);
					}
					i++;
				}
				yylval.val = atoi(yytext); 
				return(NUM);
			}
[,;{}=()]	{yylval.stringValue = strdup(yytext); return *yytext;}

.			yyerror("Invalid Character for this edition.");

[\n]		{}

%% 



int yywrap()
{
	return 1;
}


