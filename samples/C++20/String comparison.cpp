#include <string>
#include <iostream>

int main()
{
  std::string foo = "Hello world";

  std::cout << std::boolalpha;
  std::cout << foo.starts_with("Hello") << "\n";
  std::cout << foo.ends_with("monde") << "\n";
}
