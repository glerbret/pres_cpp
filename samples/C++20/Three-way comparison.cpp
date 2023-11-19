#include <compare>
#include <iostream>

struct Foo
{
  int value;

#if 1
  auto operator<=>(const Foo& rhs) const
  {
    return value <=> rhs.value;
  }
#else
  auto operator<=>(const Foo& rhs) const = default;
#endif

#if 0
  bool operator==(const Foo& rhs) const = default;
#endif

};

int main()
{
  Foo foo1{2011};
  Foo foo2{2014};

  std::cout << std::boolalpha;
  std::cout << (foo1 < foo2) << "\n";
  std::cout << (foo1 > foo2) << "\n";
#if 0
  std::cout << (foo1 == foo2) << "\n";
  std::cout << (foo1 != foo2) << "\n";
#endif
}
