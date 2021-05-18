# include <string>
# include "analizador-bison.tab.hh"
#define YY_DECL \
  yy::parseador::symbol_type yylex (parser_lexico& analizar)
YY_DECL;



class parser_lexico
{
public:
  float total;
  std::string tipo;
  void Escanear();
  void DejarDeEscanear();
  bool parse(const std::string& ingreso)
{
  file = ingreso;
  Escanear();
  yy::parseador parser(*this);
  parser.set_debug_level(false);
  bool estado = parser.parse();
  DejarDeEscanear();
  return 0;
}
  
  std::string file;
};




