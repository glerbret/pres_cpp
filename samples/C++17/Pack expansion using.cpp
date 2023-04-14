#include <iostream>
#include <string>

struct Foo
{
  int operator()(int i)
  {
    return 10 + i;
  }
};

struct Bar
{
  int operator()(const std::string& s)
  {
    return s.size();
  }
};

template <typename... Ts>
struct Baz : Ts...
{
  using Ts::operator()...;
};

int main()
{
  Baz<Foo, Bar> baz;
  std::cout << baz(5) << '\n';
  std::cout << baz("azerty") << '\n';
}
