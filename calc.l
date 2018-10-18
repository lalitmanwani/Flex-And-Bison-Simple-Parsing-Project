/*
 Name: Lalit Manwani
Binghamton ID: B00764797
Section: CS 571-02
Email Address: lmanwan1@binghamton.edu
Assignment No : 1
*/

%{
#include <stdio.h>
#include "calc.tab.h"
%}



ID	[a-z]+([A-Za-z0-9]*)	

IDE     [A-Z0-9]([0-9A-Za-z]*)


digit	([0-9])

%option yylineno

%%

"main()"	{
		return(TOK_MAIN);		
		}

"{"		{

		return(TOK_OP);		
		}


"}"		{
		return(TOK_CP);		
		}


	
"printExp"       {       return(TOK_PRINTEXPR);}			

"printID"       {       return(TOK_PRINTID);}

"int"		{
			return (TOK_INT_DT);
		}

"float"		{	return (TOK_FLOAT_DT);  
		
		}

{digit}+        {        
			yylval.int_val=atoi(yytext);
			return TOK_NUM_INT;
		}

{digit}*\.?{digit}+([eE]{digit}+)? 	{
			yylval.float_val=atof(yytext); 
			return TOK_NUM_FLOAT;
			}

{ID} 		 {
				yylval.name=strdup(yytext);
				return (TOK_ID);		
			}



{IDE} 		  {
		printf("Lexical Error : %s \n",yytext);	
			}



"="	{	return (TOK_EQUAL);	}

";"	{	return(TOK_SEMICOLON);	}

"-"	{	return(TOK_SUB);	}
"*"	{	return(TOK_MUL);	}

[ \n] 	{}
[\t]	{}

.	{printf("Lexical Error: %s \n",yytext);}

%%

int yywrap(void) {
    return 1;
}

