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
  std::expected<int, std::string> e = foo(5);

  if(e)
  {
    std::cout << "Val : " << e.value() << "\n";
  }
  else
  {
    std::cout << "Erreur : " << e.error() << "\n";
  }
}
