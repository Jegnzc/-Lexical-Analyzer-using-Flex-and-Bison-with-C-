%{

# include <cerrno>
#include <stdio.h>
#include <string>
#include "analizar.h"
#include "analizador-bison.tab.hh"

int line_num = 1;
int line_pos = 1;

#undef yywrap
#define yywrap() 1

static yy::location loc;



%}

%option noyywrap nounput batch debug noinput
%option outfile="escanear.cpp"


DIG [0-9]
ABC [a-zA-ZñÑ]


NUMERO {DIG}+("."{DIG}+)?
IDENTIFICADOR {ABC}({ABC}|{DIG}|"_")*

DELIMITADOR [\t\r\f" "]

%%
";"	        {return yy::parseador::make_PYC(loc);}
"FUNCION"	        {return yy::parseador::make_FUNCION(loc);}
"STR"	        {return yy::parseador::make_STR(loc);}
"//"	        {return yy::parseador::make_COM(loc);}
"IF"	        {return yy::parseador::make_IF(loc);}
"MAIN"	        {return yy::parseador::make_MAIN(loc);}
"INT"	        {return yy::parseador::make_INT(loc);}
"FLOAT"	        {return yy::parseador::make_FLOAT(loc);}
"BOOL"	        {return yy::parseador::make_BOOL(loc);}
"WHILE"	        {return yy::parseador::make_WHILE(loc);}
"CLASS"	        {return yy::parseador::make_CLASS(loc);}
"SWITCH"	        {return yy::parseador::make_SWITCH(loc);}
"CASE"	        {return yy::parseador::make_CASE(loc);}
"ELSE"	        {return yy::parseador::make_ELSE(loc);}
"RETORNAR"	        {return yy::parseador::make_RETORNAR(loc);}
"FOR"          {return yy::parseador::make_FOR(loc);}
"MOSTRAR"          {return yy::parseador::make_MOSTRAR(loc);}

{NUMERO}        {return yy::parseador::make_NUMERO(strtol (yytext, NULL, 10),loc);}
{IDENTIFICADOR}	{return yy::parseador::make_IDENTIFICADOR(yytext,loc);}

"+"	        {return yy::parseador::make_MAS(loc);}
">"	        {return yy::parseador::make_MAY(loc);}
">="	        {return yy::parseador::make_MAYIG(loc);}
"<="	        {return yy::parseador::make_MENIG(loc);}
"<"	        {return yy::parseador::make_MEN(loc);}
"="	        {return yy::parseador::make_IGUAL(loc);}
"-"	        {return yy::parseador::make_MENOS(loc);}
"*"	        {return yy::parseador::make_MULT(loc);}
"/"	        {return yy::parseador::make_DIV(loc);}
"("	        {return yy::parseador::make_PRNTABRIR(loc);}
")"	        {return yy::parseador::make_PRNTCERRAR(loc);}
"["	        {return yy::parseador::make_LLABRIR(loc);}
"]"	        {return yy::parseador::make_LLCERRAR(loc);}
"{"	        {return yy::parseador::make_CRCABRIR(loc);}
"}"	        {return yy::parseador::make_CRCCERRAR(loc);}

\n          { ++line_num;}


{DELIMITADOR}   {}
.               {printf("Problema de escritura detectado %s\n",yytext);}
<<EOF>>		{return yy::parseador::make_FIN(loc);}
 
%%
void parser_lexico::Escanear()
{
  yy_flex_debug = false;
  
  if((yyin = fopen (file.c_str (), "r"))!=NULL){
	std::cout<<"[archivo aceptado]\n";
  }else{
	std::cout<<"error [archivo no encontrado]\n";
	exit(1);
  }
}

void parser_lexico::DejarDeEscanear()
{
  fclose(yyin);
}
