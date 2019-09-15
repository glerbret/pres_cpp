#include <iostream>
#include <string>
#include <sstream>
#include <iomanip>

int main()
{
  std::stringstream ss;
  std::string in = "String with spaces and \"quotes\"";
  std::string out;

  ss << std::quoted(in);
  std::cout << "in:  '" << in << "'\n" << "stored as '" << ss.str() << "'\n";

  ss >> std::quoted(out);
  std::cout << "out: '" << out << "'\n";
}
