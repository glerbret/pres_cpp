#include <iostream>
#include <optional>
#include <string>

int main()
{
  {
    std::optional<std::string> foo = "Abcdef";
    auto bar = foo.transform([](auto&& s) { return s.size(); });

    std::cout << (bar ? *bar : 0) << "\n";
  }

  {
    auto func = [] (int i) -> std::optional<int> { return 2 * i; };
    std::optional<int> foo = 42;
    auto bar = foo.and_then(func);

    std::cout <<  (bar ? *bar : 0) << "\n";
  }

  {
    auto func = [] -> std::optional<std::string> { return "Oups!"; };
    std::optional<std::string> foo = "Abcdef";
    auto bar = foo.or_else(func);

    std::cout << *bar << "\n";
  }
}
