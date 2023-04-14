#include <iostream>
#include <expected>
#include <string>
#include <cstring>
#include <algorithm>
#include <iterator>

std::expected<int, std::string> foo(int i)
{
  if(i > 0)
  {
    return i;
  }
  else
  {
    return std::unexpected{"Nul"};
  }
}

int main()
{
  {
    std::expected<int, std::string> e = foo(5);
    std::cout << e.error_or("Oups") << "\n";
  }

  {
    auto func = [] (const std::string& s) 
                { 
                  std::string out;
                  std::transform(std::begin(s), std::end(s), std::back_inserter(out), 
                                 [](unsigned char c){ return std::toupper(c); } );
                  return out;
                };

    std::expected<int, std::string> e = foo(5);
    std::expected<int, std::string> e2 = e.transform_error(func);

    if(e2)
      std::cout << "Val : " << e2.value() << "\n";
    else
      std::cout << "Erreur : " << e2.error() << "\n";
  }
}
