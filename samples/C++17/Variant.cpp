#include <iostream>
#include <string>
#include <vector>
#include <variant>

int main()
{
  {
    std::variant<int, float, std::string> v, w;
    v = "xyzzy";
    std ::cout << std::get<std::string>(v) << '\n';

    v = 12;
    std ::cout << std::get<int>(v) << '\n';

    w = v;
    std ::cout << std::get<int>(w) << '\n';

#if 0
    std::get<double>(v);
    std::get<3>(v);
#endif

#if 0
    std::get<float>(w);
#endif
  }

  {
    std::vector<std::variant<int, std::string>> v{5, 10, "hello"};

    for(auto item : v)
      std::visit([](auto&& arg){std::cout << arg << ' ';}, item);
    std::cout << '\n';
  }
}
