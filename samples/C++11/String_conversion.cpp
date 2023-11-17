#include <iostream>
#include <string>

int main()
{
  int a = std::stoi("42");
  std::string b = std::to_string(56);

  std::cout << a << "\n";
  std::cout << b << "\n";
}
