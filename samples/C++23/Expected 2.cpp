#include <iostream>
#include <expected>
#include <string>

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
    std::cout << "Val : " << e.value_or(-1) << "\n";
  }

  {
    std::expected<int, std::string> e = foo(5);
    std::expected<int, std::string> e2 = e.transform([] (int i) { return 2 * i; });

    if(e2)
      std::cout << "Val : " << e2.value() << "\n";
    else
      std::cout << "Erreur : " << e2.error() << "\n";
  }

  {
    auto func = [] (int i) -> std::expected<int, std::string> 
                { return 2 * i; };
    std::expected<int, std::string> e = foo(5);
    std::expected<int, std::string> e2 = e.and_then(func);

    if(e2)
      std::cout << "Val : " << e2.value() << "\n";
    else
      std::cout << "Erreur : " << e2.error() << "\n";
  }

  {
    auto func = [] (const std::string& error) -> std::expected<int, std::string> 
                { std::cout << "Oups! " << error << "\n"; 
                  return -1; };
    std::expected<int, std::string> e = foo(5);
    std::expected<int, std::string> e2 = e.or_else(func);

    if(e2)
      std::cout << "Val : " << e2.value() << "\n";
    else
      std::cout << "Erreur : " << e2.error() << "\n";
  }
}
