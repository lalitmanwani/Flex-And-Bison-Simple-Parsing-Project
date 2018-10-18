/*
 Name: Lalit Manwani
Binghamton ID: B00764797
Section: CS 571-02
Email Address: lmanwan1@binghamton.edu
Assignment No : 1
*/


%{
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
extern int yylineno;

typedef struct
{
char id[100];
int int_no;
float float_no;
char *type;
}symbol;
symbol stable[10];/*Symbol Table as struture array*/
int sc = 0;/*Symbol Table global variable*/


//Function definations for the parsing of file

void updateit(char *s,int x,float y);
void view(char *s);
void addq(char *s);
void addf(char *s);
int lookupi(char *s);
float lookupf(char *s);
char *typ(char *s);
void print(char *s);
int lookup(char *s);

%}

%token TOK_SEMICOLON TOK_SUB TOK_MUL TOK_NUM_INT TOK_NUM_FLOAT TOK_PRINTID TOK_ID TOK_EQUAL TOK_INT_DT TOK_FLOAT_DT TOK_MAIN TOK_OP TOK_CP TOK_PRINTEXPR

%union{
        int int_val;
	float float_val;
	char *name;
 /* Structure to store identifiers, their respective values and datatypes */	

struct s_expr
{
		/*supposed that event a identifier will be a expr becuase, a variable might be referenced later on via the identifier */
char *id;	/* stores name of the identifiers */
int ino;	/* Store int values */
float fno;	/* Store float values */
char *type;	/* Store the data type */ 
}struct_expr;  /* this is instance of s_expr data-type which will be used to declare a token */


}

%type <int_val> TOK_NUM_INT
%type <float_val> TOK_NUM_FLOAT
%type <name> TOK_ID	
%type <struct_expr> expr


%right TOK_EQUAL
%left TOK_SUB
%left TOK_MUL

%%

S:	|S TOK_MAIN TOK_OP program TOK_CP
; 

program:  | program var TOK_SEMICOLON | program expr_stmt TOK_SEMICOLON 
;

var:	 TOK_INT_DT TOK_ID
		{
		addq($2);	

		}

	|TOK_FLOAT_DT TOK_ID
		{
		addf($2);
		
		}

;

expr_stmt:
	 TOK_PRINTID TOK_ID
		{
		view($2);
		
		} 

	| TOK_PRINTEXPR expr
		{

		if(0 == strcmp("FLOAT",$2.type)){
		printf("\n %f \n",$2.fno);
		}
		else if(0 == strcmp("INT",$2.type))
		{
		printf("\n %d \n",$2.ino);				
		}
		
		}

	| TOK_ID TOK_EQUAL expr
		{
		
		int a;
		a  = lookup($1);		
		if(a == 0)
		{
		yyerror(strcat($1," \t is used but not declared"));		
		}
		
		char *x = typ($1);
		if(-1 == strcmp(x,$3.type))
		{
		yyerror("Type Error");		
		}
		
		if(-1 == strcmp($3.type,x))
		{
		yyerror("Type Error");		
		}	

		
		updateit($1,$3.ino,$3.fno);	
		
		}		
;

expr: 	 
	 expr TOK_SUB expr
	  {
		if($1.type == $3.type)
	{			
		if(0 == strcmp("FLOAT",$1.type)){
		$$.fno = $1.fno - $3.fno;
		$$.type ="FLOAT";
		}
		else if(0 == strcmp("INT",$1.type))
		{
		$$.ino = $1.ino - $3.ino;
		$$.type = "INT";		
		}
		}
		else
		{
		yyerror("Type Error");		
		}

		
		}

	  
	| expr TOK_MUL expr
	  {
		if($1.type == $3.type)
		{			
		if(0 == strcmp("FLOAT",$1.type)){
		$$.fno = $1.fno * $3.fno;
		$$.type ="FLOAT";
		}
		else if(0 == strcmp("INT",$1.type))
		{
		$$.ino = $1.ino * $3.ino;
		$$.type ="INT";		
		}

		}
		else
		{
		yyerror("Type Error");		
		}
		
		}	


	| TOK_NUM_INT
	  { 	
		$$.type= "INT";		
		$$.ino = $1;
		
	  }

	| TOK_NUM_FLOAT
	  { 	

		$$.type= "FLOAT";
		$$.fno = $1;
	  }

	| TOK_ID
	  {		
		
		char *x = typ($1);
		
		if(0 == strcmp("FLOAT",x))
		{
		$$.fno = lookupf($1);
		$$.type="FLOAT";
		}
		
		if(0 == strcmp("INT",x))
		{
		$$.ino = lookupi($1);
		$$.type="INT";		
		}
			
	  }

;


%%

/* Function to update the expression stmt */

void updateit(char *s,int x,float y)
{
char a[100];
strcpy(a,s);

int i;

i = x;

float f;
f = y;

char *rt = NULL;
int k=0;

while(k <= 10)
{
if(0 == strcmp(stable[k].id,a))
{
rt = stable[k].type;

if(0 == strcmp("INT",rt))
{
stable[k].int_no  = i;
}
else if(0 == strcmp("FLOAT",rt))
{
stable[k].float_no  = f;
}}
k++;
}
}


/* Function to return the type of datatype */
char *typ(char *s)
{
char a[100];
strcpy(a,s);

char *rt;

int k=0;

while(k <= 10)
{
if(0 == strcmp(stable[k].id,a))
{
rt = stable[k].type;
}
k++;
}

return rt;
}

/* Function to lookup the identifiers  */

int lookup(char *s)
{

char a[100];

strcpy(a,s);

int i  = 0;

int k= 0;

while(k <= 10)
{
if(0 == strcmp(stable[k].id,a))
{
i = 1;
}

k++;
}
return i;
}

/* Function to return the integer value of a int datatype identifier */

int lookupi(char *s)
{
char a[100];

strcpy(a,s);

int rt;

int k=0;

while(k <= 10)
{
if(0 == strcmp(stable[k].id,a))
{
rt = stable[k].int_no;
}

k++;
}

return rt;

}


/* Function to return the float value of a int datatype identifier */
float lookupf(char *s)
{

char a[100];

strcpy(a,s);

float rt;

int k=0;

while(k <= 10)
{
if(0 == strcmp(stable[k].id,a))
{
rt = stable[k].float_no;
}

k++;
}

return rt;
}


/* Function to add the integer value of a int id into symbol table */
void addq(char *s)
{
int y = 0;
char b[100];

strcpy(b,s);

stable[sc].type = "INT";

strcpy(stable[sc].id,b);

stable[sc].int_no = y;
sc++;
}

/* Function to add the float value of a float id into symbol table */

void addf(char *s)
{

float y = 0.0000;

char b[100];


strcpy(b,s);

stable[sc].type = "FLOAT";

strcpy(stable[sc].id,b);

stable[sc].float_no = y;
sc++;
}

/* Function to print the printID values*/
void view(char *s)
{

char a[100];
strcpy(a,s);

char *rt;

int k=0;

while(k <= 10)
{
if(0 == strcmp(stable[k].id,a))
{
rt = stable[k].type;
if(0 == strcmp("INT",rt))
{
printf("\n %d \n",stable[k].int_no);
}
else if(0 == strcmp("FLOAT",rt))
{
printf("\n %f \n",stable[k].float_no);
}}
k++;
}
}




int yyerror(char *s)
{
	printf("\n Parsing Error : Line no %d : %s \n",yylineno,s);
		exit(0);	

}


int main()
{
  yyparse();
   return 0;
}
