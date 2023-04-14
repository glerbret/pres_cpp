#include <iostream>
#include <string>
#include <string_view>

int main()
{
  const std::string foo = "Hello world";
  std::cout << std::boolalpha;
  std::cout << foo.contains("Hello") << "\n";
  std::cout << foo.contains("monde") << "\n";

  std::string_view bar = foo;
  std::cout << bar.contains("Hello") << "\n";
  std::cout << bar.contains("monde") << "\n";
}
