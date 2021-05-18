#include <stdio.h>
#include "analizar.h"

using namespace std;

int main()
{
  parser_lexico analizar;
  string entrada = "entrada.txt";
  analizar.parse(entrada);
  return 0;
}
