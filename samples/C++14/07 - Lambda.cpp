#include <iostream>
#include <string>

using namespace std::literals;

int main()
{
  {
    auto foo = [] (auto in) { std::cout << in << '\n'; };

    foo(2);
    foo("azerty"s);
  }

  {
    auto foo = [] (auto... args) { std::cout << sizeof...(args) << '\n'; };

    foo(2);
    foo(2, 3, 4);
    foo("azerty"s);
  }

  {
    int foo = 42;

    auto bar = [ &x = foo ]() { --x; };
    bar();
    std::cout << foo << '\n';

    auto baz = [ y = 2*foo ]() { std::cout << y << '\n'; };
    baz();
  }
}
