%{
	// Adding all the header files and function definations
	#include<stdio.h>
	#include<stdlib.h>
	#include<math.h>
	#include<string.h>
	int yylex(void);
	void yyerror(char *s);
	FILE *yyin, *yyout;
	
	int no_var = 0;		// This variable will keep track of the total variables used.
	int no_fun = 0;		//number of functions
	char *str_tmp;

	//------------------------------------------------------------------------------------
	// Defining a structure to handle the properties of variables.
	
	struct variable_structure{
		char var_name[20];
		int var_type;
		int ival;
		float fval;
		char cval;
		char *sval;
	}variable[100];


	// Defining a structure and necessary functions to handle the properties of Functions.
	struct function_structure{
		char fun_name[20];
		int return_type;
		
	}functions[100];
	
	int search_fun(char name[20]){
		int i;
		for(i=0; i<no_fun; i++){
			if(!strcmp(functions[i].fun_name, name)){
				return 1;
			}
		}
		return 0;
	}

	int get_fun_index(char name[20]){
		int i;
		for(i=0; i<no_fun; i++){
			if(!strcmp(functions[i].fun_name, name)){
				return i;
			}
		}
		return -1;
	}

	// Function for searching if the present variable name has already been used.
	int search_var(char name[20]){
		int i;
		for(i=0; i<no_var; i++){
			if(!strcmp(variable[i].var_name, name)){
				return 1;
			}
		}
		return 0;
	}

	// Setting the type of a variable (in integer value)
	void set_var_type(int type){
		int i;
		for(i=0; i<no_var; i++){
			if(variable[i].var_type == -1){
				variable[i].var_type = type;
			}
		}
	}
	
	// Finind the index of any variable
	int get_var_index(char name[20]){
		int i;
		for(i=0; i<no_var; i++){
			if(!strcmp(variable[i].var_name, name)){
				return i;
			}
		}
		return -1;
	}
	
%}

%union{
	double val;
	char* stringValue;
}

// Defining all the used tokens and precendences of the required ones.

%error-verbose

%token CHR STR MAIN INT VOID CHAR FLOAT STRING MAX MIN POW FACTO PRIME READ PRINT SWITCH CASE DEFAULT IF ELIF ELSE FROM TO WHILE INC DEC ASSIGN PLUS MINUS MUL DIV EQUAL NOTEQUAL GT GTE LT LTE SIN COS TAN LN LOG10 LOG2 ID NUM FUN

%nonassoc ELIF 
%nonassoc ELSE
%left PLUS MINUS
%left LOG10 LOG2 LN  
%left EQUAL NOTEQUAL GT GTE LT LTE
%left MUL DIV
%right  POW FACTORIAL
%left SIN COS TAN


// Defining token type

%type<val> s_assignment fun_code fun_type prime_code factorial_code casenum_code default_code case_code switch_code e f t expression else_if elsee bool_expression power_code min_code max_code declaration assignment condition for_code while_code print_code read_code program code TYPE MAIN INT VOID FLOAT  MAX MIN POW FACTO PRIME READ PRINT SWITCH CASE DEFAULT IF ELIF ELSE FROM TO WHILE INC DEC ASSIGN PLUS MINUS MUL DIV EQUAL NOTEQUAL GT GTE LT LTE SIN COS TAN LN LOG10 LOG2 NUM range1 while_condition sine_code cos_code tan_code ln_code log2_code log10_code FUN

%type<stringValue> ID1 ID STRING CHAR STR CHR


%%

// Rules for the code using tokens

program: CAT MAIN '{' code '}'
		{
			printf("\n\nProgram runs successfully!!!\n\n");				
		}
		| {}
		;
CAT:{}
	| FUN fun_type ID '(' ')' '{' code '}' CAT
		{
			printf("\n%s Function detected...!! \n", $3);
			if(search_fun($3)==0){
				printf("\nValid function declaration");
				strcpy(functions[no_fun].fun_name, $3);
				functions[no_fun].return_type =  $2;
				printf("\nFunction name: %s", functions[no_fun].fun_name);
				printf("\nReturn type: %d", functions[no_fun].return_type);
				no_fun = no_fun + 1;
				printf("\nTotal number of functions: %d\n\n", no_fun);
			}
			else{
				printf("\n\n(%s)...Function has already been declared.....!!!", $3);
			}
		}

fun_type: INT	{$$ = 1; printf("\nReturn type: Integer");}
	| FLOAT	{$$ = 2; printf("\nReturn type: Float");}
	| CHAR	{$$ = 0; printf("\nReturn type: Character");}
	| STRING {$$ = 3; printf("\nReturn type: String");}
	| VOID {$$ = 4; printf("\nReturn type: Void");}
	;


code: declaration code
	| assignment code
	| s_assignment code
	| condition code
	| for_code code
	| while_code code
	| switch_code code
	| print_code code
	| read_code code
	| power_code ';'   code
	| factorial_code ';'  code
	| prime_code ';'  code
	| min_code ';'  code
	| max_code ';'  code
	| sine_code ';' code
	| cos_code ';' code
	| tan_code ';' code
	| ln_code ';' code
	| log10_code ';' code
	| log2_code ';' code
	| fun_code ';' code 
	| {}
	;


// CFG for variable declaration ---------------------------------------

declaration: TYPE ID1 ';' {
	set_var_type($1);
}
;
TYPE: INT	{$$ = 1; printf("\ntype: Integer");}
	| FLOAT	{$$ = 2; printf("\ntype: Float");}
	| CHAR	{$$ = 0; printf("\ntype: Character");}
	| STRING {$$ = 3; printf("\ntype: String");}
	;



ID1: ID1 ',' ID 
	{
		if(search_var($3)==0){
			printf("\nValid declaration");
			strcpy(variable[no_var].var_name, $3);
			printf("\nVariable name--> %s", $3);
			variable[no_var].var_type =  -1;
			no_var = no_var + 1;
		}
		else{
			printf("\n\n(%s)...Variable has already been declared.....!!!", $1);
		}
	} 
	| ID 
	{
		if(search_var($1)==0){
			printf("\nValid declaration");
			strcpy(variable[no_var].var_name, $1);
			printf("\nVariable name--> %s", $1);
			variable[no_var].var_type =  -1;
			no_var = no_var + 1;
		}
		else{
			printf("\n\n(%s)...Variable has already been declared.....!!!", $1);
		}
		strcpy($$, $1);
	}
	;



assignment: ID ASSIGN expression ';' {
	$$ = $3;
	if(search_var($1)==1){
		int i = get_var_index($1);
		if(variable[i].var_type==1){
			variable[i].ival = $3;
			printf("\nVariable value--> %d", variable[i].ival);
		}
		else if(variable[i].var_type==2){
			variable[i].fval = (float)$3;
			printf("\nVariable value--> %f", variable[i].fval);
		}
	}
	else{
		printf("\nVariable is not declared\n");
	}
}
;
s_assignment: ID ASSIGN STR ';' {
	str_tmp = $3;
	if(search_var($1)==1){
		int i = get_var_index($1);
		if(variable[i].var_type==0){
			variable[i].cval = str_tmp[1];
			printf("\nVariable value--> %c", variable[i].cval);
		}
		else if(variable[i].var_type==3){
			variable[i].sval = str_tmp;
			printf("\nVariable value--> %s", variable[i].sval);
		}
	}
	else{
		printf("\nVariable is not declared\n");
	}
}
;


//CFG for expression-----------------------------------------------------

expression: e {$$ = $1;}
;

e: e PLUS f {$$ = $1 + $3; }
	| e MINUS f {$$ = $1 - $3;}
	| f      {$$ = $1;}
	| power_code {$$ = $1;}
	| factorial_code {$$ = $1;}
	| prime_code {$$ = $1;}
	| max_code {$$ = $1;}
	| min_code {$$ = $1;}
	| sine_code  {$$ = $1;}
	| cos_code  {$$ = $1;}
	| tan_code  {$$ = $1;}
	| ln_code {$$ = $1;}
	| log10_code {$$ = $1;}
	| log2_code {$$ = $1;}
	| fun_code {$$=$1;}
	;

f:  f MUL t {$$ = $1 * $3;}
	| f DIV t 
	{
		if($3 != 0)
		{
			$$ = $1 / $3;
		}
		else{
			printf("\nMathematically invalid expression");
		}
	}
	| t   {$$ = $1;}
	;

t: '(' e ')' {$$ = $2;}
	| ID {
		int id_index = get_var_index($1);
		if(id_index == -1)
		{
			yyerror("VARIABLE DOESN'T EXIST");
		}
		else
		{
			if(variable[id_index].var_type == 1)
			{
				$$ = variable[id_index].ival;
			}
			else if(variable[id_index].var_type == 2)
			{
				$$ = variable[id_index].fval;
			}
			
		}
	}
	| NUM  {$$ = $1;}
	;

fun_code: ID '(' ')'{
	if(search_fun($1)==1){
		int i = get_fun_index($1);
		//printf("\nIndex: %d\n", i);
		int x = functions[i].return_type;
		$$ = x;
		printf("\n[%s] Function is called\n", $1);
	}
	else{
		printf("\n---------Function is not declared-------\n");
	}
} 
;


//CFG for print() function---------------DONE---------------------------
	
print_code: PRINT '(' ID ')'';'{
	int i = get_var_index($3);
	if(variable[i].var_type == 1){
		printf("\nPrint Variable name: %s, Value: %d", variable[i].var_name, variable[i].ival);
	}
	else if(variable[i].var_type == 2){
		printf("\nPrint Variable name: %s, Value: %f", variable[i].var_name, variable[i].fval);
	}
	else if(variable[i].var_type == 3){
		printf("\nPrint Variable name: %s, Value: %s", variable[i].var_name, variable[i].sval);
	}
	else{
		printf("\nPrint Variable name: %s, Value: %c", variable[i].var_name, variable[i].cval);
	}
}
;


//CFG for read() funtion----------DONE----------
	
read_code: READ '(' ID ')'';'{
	if(search_var($3)==1){
		int i = get_var_index($3);
		printf("\nRifat %s %d\n", $3, i);
		if(variable[i].var_type==1){
			scanf("%d", &variable[i].ival);
		}
		else if(variable[i].var_type==2){
			scanf("%f", &variable[i].fval);
		}
		else if(variable[i].var_type==0){
			getchar();
			scanf("%c", &variable[i].cval);
		}
		else if(variable[i].var_type==3){
			char temp[2000];
			scanf("%s", &temp);
			variable[i].sval = temp;
		}
	}
	else{
		printf("\nVariable is not declared\n");
	}
}
;


//CFG for Pow() function------------------------DONE-----------------------

power_code: POW '(' NUM ',' NUM ')'{		
	int i;
	i = pow($3, $5);
	$$ = i;
	printf("\nPower function value: %d \n", i);
}
| POW '(' ID ',' ID ')'	{		
	if(search_var($3)==1 && search_var($5)==1){
		int i = get_var_index($3);
		int j = get_var_index($5);
		if((variable[i].var_type==1) && (variable[j].var_type==1)){
			int a = variable[i].ival;
			int b = variable[j].ival;
			
			int n = pow(a, b);
			$$ = n;
			printf("\nVariable value--> %d", n);
		}
		else{
			printf("The types should be in integer form.");
		}
		
	}
	else{
		printf("\nVariable is not declared\n");
	}
}
;



//CFG for Sine() function------------------------DONE-----------------------

sine_code: SIN '(' NUM ')'{		
	float i;
	i = sin($3);
	$$ = i;
	printf("\nSin result: %f \n", i);
}
| SIN '(' ID ')'	{		
	if(search_var($3)==1){
		int i = get_var_index($3);
		float res;
		if(variable[i].var_type==1){
			int n = variable[i].ival;
			res = sin(n);
		}
		else if(variable[i].var_type==2){
			float n = variable[i].fval;
			res = sin(n);
		}
		$$ = res;
		printf("\nSin result: %f \n", res);
	}
	else{
		printf("\nVariable is not declared\n");
	}
}
;



cos_code: COS '(' NUM ')'{		
	float i;
	i = cos($3);
	$$ = i;
	printf("\nCosine result: %f \n", i);
}
| COS '(' ID ')'	{		
	if(search_var($3)==1){
		int i = get_var_index($3);
		float res;
		if(variable[i].var_type==1){
			int n = variable[i].ival;
			res = cos(n);
		}
		else if(variable[i].var_type==2){
			float n = variable[i].fval;
			res = cos(n);
		}
		$$ = res;
		printf("\nCosine result: %f \n", res);
	}
	else{
		printf("\nVariable is not declared\n");
	}
}
;



tan_code: TAN '(' NUM ')'{		
	float i;
	i = tan($3);
	$$ = i;
	printf("\nTangent result: %f \n", i);
}
| TAN '(' ID ')'	{		
	if(search_var($3)==1){
		int i = get_var_index($3);
		float res;
		if(variable[i].var_type==1){
			int n = variable[i].ival;
			res = tan(n);
		}
		else if(variable[i].var_type==2){
			float n = variable[i].fval;
			res = tan(n);
		}
		$$ = res;
		printf("\nTangent result: %f \n", res);
	}
	else{
		printf("\nVariable is not declared\n");
	}
}
;




//CFG for Ln() function------------------------DONE-----------------------

ln_code: LN '(' NUM ')'{		
	float i;
	int x = $3;
	i = log(x);
	$$ = i;
	printf("\nLn result: %f \n", i);
}
| LN '(' ID ')'	{		
	if(search_var($3)==1){
		int i = get_var_index($3);
		if(variable[i].var_type==1){
			int a = variable[i].ival;
			float n = log(a);
			$$ = n;
			printf("\nLn result: %f \n", n);
		}
		else{
			printf("\nType should be integer\n");
		}
	}
	else{
		printf("\nVariable is not declared\n");
	}
}
;


log10_code: LOG10 '(' NUM ')'{		
	float i;
	int x = $3;
	i = log10(x);
	$$ = i;
	printf("\nLog10 result: %f \n", i);
}
| LOG10 '(' ID ')'	{		
	if(search_var($3)==1){
		int i = get_var_index($3);
		if(variable[i].var_type==1){
			int a = variable[i].ival;
			float n = log10(a);
			$$ = n;
			printf("\nLog10 result: %f \n", n);
		}
		else{
			printf("\nType should be integer\n");
		}
	}
	else{
		printf("\nVariable is not declared\n");
	}
}
;




log2_code: LOG2 '(' NUM ')'{		
	float i;
	int x = $3;
	i = log2(x);
	$$ = i;
	printf("\nLog2 result: %f \n", i);
}
| LOG2 '(' ID ')'	{		
	if(search_var($3)==1){
		int i = get_var_index($3);
		if(variable[i].var_type==1){
			int a = variable[i].ival;
			float n = log2(a);
			$$ = n;
			printf("\nLog2 result: %f \n", n);
		}
		else{
			printf("\nType should be integer\n");
		}
	}
	else{
		printf("\nVariable is not declared\n");
	}
}
;




//CFG for Facto()--------------------DONE--------------------

factorial_code: FACTO '(' NUM ')' {
	int j = $3;
	int i, result;
	result = 1;
	if(j==0){
		printf("\nFactorial of %d is %d", j, result);
	}
	else{
		for(i = 1; i <= j; i++){
			result = result*i;
		}
		$$ = result;
		printf("\nFactorial of %d is %d", j, result);
	}	
}
| FACTO '(' ID ')' {
	if(search_var($3)==1){
		int i = get_var_index($3);
		if(variable[i].var_type==1){
			int a = variable[i].ival;
			int i, result;
			result=1;
			if(a==0){
				printf("\nFactorial of %d is %d", a, result);
			}
			else{
				for(i = 1; i <= a; i++){
					result = result*i;
				}
				$$ = result;
				printf("\nFactorial of %d is %d",a, result);
			}	
		}
		else{
			printf("The types should be in integer form.");
		}
		
	}
	else{
		printf("\nVariable is not declared\n");
	}

}
;	





//CFG for CheckPrime()-----------------DONE------------------------
	
prime_code: PRIME '(' NUM ')' {
	int n, i, flag = 1;
	n = $3;
	for (i = 2; i <= n / 2; ++i) {
		if (n % i == 0) {
			flag = 0;
			break;
		}
	}
	$$ = flag;
    printf("\n%d", flag);
}
| PRIME '(' ID ')' {
	if(search_var($3)==1){
		int i = get_var_index($3);
		if(variable[i].var_type==1){
			int n = variable[i].ival;
			int flag = 1;
			for (i = 2; i <= n / 2; ++i) {
				if (n % i == 0) {
					flag = 0;
					break;
				}
			}
			$$ = flag;
    		printf("\n%d", flag);	
		}
		else{
			printf("\nThe types should be in integer form.\n");
		}
		
	}
	else{
		printf("\nVariable is not declared\n");
	}
}
;




//CFG for Max()--------------------DONE----------------

max_code: MAX '(' ID ',' ID')'{
	int i = get_var_index($3);
	int j = get_var_index($5);
	int k,l;
	if((variable[i].var_type == 1) &&(variable[j].var_type == 1) ){
		k = variable[i].ival;
		l = variable[j].ival;
		if(l>=k){
			$$ = l;
			printf("\nMax value is--> %d", l);
		}
		else{
			$$ = k;
			printf("\nMax value is--> %d", k);
		}
	}
	else if((variable[i].var_type == 2) &&(variable[j].var_type == 2) ){
		float k1 = variable[i].fval;
		float l1 = variable[j].fval;
		if(l1>=k1){
			$$ = l1;
			printf("\nMax value is--> %f", l1);
		}
		else{
			$$ = k1;
			printf("\nMax value is--> %f", k1);
		}
	}
	else{
		printf("\nNot integer or float variable");
	}
}
| MAX '(' NUM ',' NUM')'{
	float l = $3;
	float k = $5;
	if(l>=k){
		$$ = l;
		printf("\nMax value is--> %f", l);
	}
	else{
		$$ = k;
		printf("\nMax value is--> %f", k);
	}	
}
;




//CFG for Min()--------------------DONE----------------

min_code: MIN '(' ID ',' ID')'{
	int i = get_var_index($3);
	int j = get_var_index($5);
	int k,l;
	if((variable[i].var_type == 1) &&(variable[j].var_type == 1) ){
		k = variable[i].ival;
		l = variable[j].ival;
		if(l<=k){
			$$ = l;
			printf("\nMin value is--> %d", l);
		}
		else{
			$$ = k;
			printf("\nMin value is--> %d", k);
		}
	}
	else if((variable[i].var_type == 2) &&(variable[j].var_type == 2) ){
		float k1 = variable[i].fval;
		float l1 = variable[j].fval;
		if(l1<=k1){
			$$ = l1;
			printf("\nMin value is--> %f", l1);
		}
		else{
			$$ = k1;
			printf("\nMin value is--> %f", k1);
		}
	}
	else{
		printf("\nNot integer or float variable");
	}
}
| MIN '(' NUM ',' NUM')'{
	float l = $3;
	float k = $5;
	if(l<=k){
		$$ = l;
		printf("\nMin value is--> %f", l);
	}
	else{
		$$ = k;
		printf("\nMin value is--> %f", k);
	}	
}
;
	



// CFG for from-to loop (For Loop)--------DONE-----------------

for_code: FROM range1 TO range1 INC range1 '{' code '}' {
	printf("\nFor loop detected");
	
	int i = $2;
	int j = $4;
	int inc = $6;
	int k;
	for(k=i; k<=j; k+=inc){
		printf("value of looping: %d\n", k);
	}
}
;

range1: ID {
	int i = get_var_index($1);
	int val = variable[i].ival;
	$$ = val;		
}
| NUM {
	$$ = $1;
}
;




//CFG for while loop------------------PENDING-------------------

while_code: WHILE '(' while_condition ')''{' code '}'{
	printf("\nwhile loop detected\n");
	int i = $3;
	if(i==0){
		printf("This condition is false\n");
	}
	else{
		while(i!=0){
			printf("\nWhile Loop running--> %d", i);
			i--;
		}
	}
	
}
;

while_condition: expression NOTEQUAL expression {
	if($1!=$3){
		$$ = abs($1-$3);
	}
	else{
		$$ = 0;
	}
}
| expression GT expression {
	if($1>$3){
		$$ = ($1-$3);
	}
	else{
		$$ = 0;
	}
}
| expression LT expression {
	if($1<$3){
		$$ = ($3-$1);
	}
	else{
		$$ = 0;
	}
}
;





// CFG for switch-case--------------DONE-----------------

switch_code: SWITCH '(' ID ')' '{' case_code '}' {
	printf("\nSwitch-case structure detected.");
}
	;
case_code: casenum_code default_code
	;

casenum_code: CASE NUM '{' code '}' casenum_code {
	printf("\nCase no--> %d", $2);
}
	|{}
	;
default_code: DEFAULT '{' code '}'
	;



	

//CFG for if-elif-else structure----------------------------
	
condition: IF'(' bool_expression ')''{'code'}' else_if elsee {
	printf("\nIF condition detected");
	int i = $3;
	if(i==1){
		printf("\nIF condition is true");
	}
	else{
		printf("\nIF condition false");
	}
}
;

else_if: ELIF '(' bool_expression ')''{' code '}' else_if {
	printf("\nELIF condition detected");
	int i = $3;
	if(i==1){
		printf("\nELIF condition true");
	}
	else{
		printf("\nELIF condition false");
	}
}
|{}
;

elsee: ELSE '{' code '}' {
	printf("\nELSE condition is detected");
}
|{}
;
	



//CFG for evaluating boolian expression

bool_expression: expression EQUAL expression {
	if($1==$3){
		$$ = 1;
	}
	else{
		$$ = 0;
	}
}
				| expression NOTEQUAL expression {
	if($1!=$3){
		$$ = 1;
	}
	else{
		$$ = 0;
	}
}
				| expression GT expression {
	if($1>$3){
		$$ = 1;
	}
	else{
		$$ = 0;
	}
}
				| expression GTE expression {
	if($1>=$3){
		$$ = 1;
	}
	else{
		$$ = 0;
	}
}
				| expression LT expression {
	if($1<$3){
		$$ = 1;
	}
	else{
		$$ = 0;
	}
}
				| expression LTE expression {
	if($1<=$3){
		$$ = 1;
	}
	else{
		$$ = 0;
	}
}
	;

%%


void yyerror(char *s)
{
	fprintf(stderr, "\n%s", s);
}

int main(){
	yyin = fopen("test.txt", "r");
	yyout = freopen("testout.txt", "w", stdout);
	yyparse();
	return 0;
}
