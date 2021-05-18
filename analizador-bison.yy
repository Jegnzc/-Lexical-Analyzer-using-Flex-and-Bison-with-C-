%skeleton "lalr1.cc" /* -*- C++ -*- */
%require "3.0.2"
%defines
%define parser_class_name {parseador}
%define api.token.constructor
%define api.namespace {yy}
%define api.value.type variant
%define parse.assert
%code requires
{
#include <string>
#include <stdio.h>
extern int line_num;
extern int line_pos;
class parser_lexico;
}
%param { parser_lexico& analizar }
%locations
%define parse.trace
%define parse.error verbose
%code
{
#include "analizar.h"
#include <iostream>
}
%define api.token.prefix {TOK_}

//Listadode Terminales
%token <std::string> IDENTIFICADOR "id"
//~ %token <std::string> COMENTARIO "com"
%token <float> NUMERO "num"
%token FIN 0 "eof"
%token IF "IF"
%token MAS "+"
%token MENOS "-"
%token DIV "/"
%token MULT "*"
%token PRNTABRIR "("
%token PRNTCERRAR ")"
%token PYC ";"
%token IGUAL "="
%token CRCABRIR "{"
%token CRCCERRAR "}"
%token MAIN "MAIN"
%token LLABRIR "["
%token LLCERRAR "]"
%token INT "INT"
%token FLOAT "FLOAT"
%token COM "//"
%token MAYIG ">="
%token MAY ">"
%token MEN "<"
%token MENIG "<="
%token FUNCION "FUNCION"
%token STR "STR"
%token BOOL "BOOL"
%token WHILE "WHILE"
%token CLASS "CLASS"
%token SWITCH "SWITCH"
%token CASE "CASE"
%token ELSE "ELSE"
%token RETORNAR "RETORNAR"
%token FOR "FOR"
%token MOSTRAR "MOSTRAR"

//~ %token <std::string> COMENTARIO "com"


%printer { yyoutput << $$; } <*>;
%%
%start I;

I : "MAIN" "[" RESERVADAS "]" {std::cout<<"Código aceptado.\n";return 0;};

RESERVADAS : INSTRUCCIONES RESERVADAS
           | %empty;


STRING : "id" STRING
       | %empty;

COMENTARIO : "//" STRING "//";

COMP1 : "id"
      | "num";

COMP : COMP1 RELACIONALES COMP1;

IFCOND : "IF" "(" COMP ")" "[" REPETIRINSTRUCCIONES "]" ELSEAR;

ELSEAR : "ELSE" "[" REPETIRINSTRUCCIONES "]"
       | %empty

FUNCION1 : "FUNCION" "id" "(" ASIGPARAMETRO ")" "[" REPETIRINSTRUCCIONES "]";

SHIFT : "SWITCH" "(" "id" ")" "[" OPCIONESCASE "]"

FUNCIONLLAMADA : "id" "(" ASIGPARAMETRO ")"

RETORNAR2 : "id" ";"
          | "num" ";"
          | REPETIRFUNCIONLLAMADA ";";
 
RETORNAR1 : "RETORNAR" RETORNAR2;

POSIBLESSIMBOLOS : "+"
                 | "-"
                 | "*"
                 | "/"
                 | %empty;

MOST : "MOSTRAR" "//" STRING "//" ";"

REPETIRFUNCIONLLAMADA : FUNCIONLLAMADA POSIBLESSIMBOLOS REPETIRFUNCIONLLAMADA
                      | %empty;

CASEAR : "CASE" "num" "[" REPETIRINSTRUCCIONES "]";

CLASE : "CLASS" "id" "[" REPETIRINSTRUCCIONES "]";

FOR1 : "FOR" "(" ASIGNACIONNUMERO COMP ";" "id" MENTOS ")" "[" REPETIRINSTRUCCIONES "]"

MENTOS : "+" "+"
       | "-" "-";


OPCIONESCASE : CASEAR OPCIONESCASE
             | %empty;

INSTRUCCIONES : OPERACIONENTERA
              | COMENTARIO
              | ASIGNACIONNUMERO
              | ASIGNACIONSTRING
              | IFCOND
              | FUNCION1
              | ASIGNACIONCOMPLETASTRING
              | SHIFT
              | CLASE
              | FUNCIONLLAMADA ";"
              | RETORNAR1
              | FOR1
              | MOST;

REPETIRINSTRUCCIONES : INSTRUCCIONES REPETIRINSTRUCCIONES
                     | %empty;

TIPOSDENUMEROS : "INT" | "FLOAT";

ASIGNACIONNUMERO4 : "=" "num"
                  | "=" OPERACION;

ASIGNACIONNUMERO3 : "=" OPERACION 
                  | "=" "num" 
                  | "[" "num" "]" ASIGNACIONNUMERO4
                  | "=" FUNCIONLLAMADA;
                  | %empty;


ASIGNACIONNUMERO2 : "id" ASIGNACIONNUMERO3 ";";
              
ASIGNACIONNUMERO : TIPOSDENUMEROS ASIGNACIONNUMERO2 
                 | ASIGNACIONNUMERO2;              
                 
ASIGNACIONSTRING : "STR" "id" ";";

ASIGNACIONCOMPLETASTRING : "STR" "id" "=" "//" STRING "//" ";";

ASIGPARAMETRO : PARAPARAMETRO ASIGPARAMETRO
              | %empty;

PARAPARAMETRO : TIPOSDENUMEROS "id"
              | "STR" "id"
              | "id"
              | "num";

OPERACIONENTERA : "id" "=" OPERACION ";";

RELACIONALES : ">"
             | ">="
             | "<"
             | "<=";

//~ OPERACIONES CON NÚMEROS Y VARIABLES

OPERACION  : OPERACION2 | OPERACION "+" OPERACION2 | OPERACION "-" OPERACION2
OPERACION2 : OPERACION3 | OPERACION2 "*" OPERACION3 | OPERACION2 "/" OPERACION3
OPERACION3 : "num" | "id" | "(" OPERACION ")"
%%
void yy::parseador::error(const location_type& lugar, const std::string& lexema)
{
  std::cout << "//" << lexema <<" en linea " << line_num <<" //\n";
}
