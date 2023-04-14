#include <iostream>

struct Foo
{
#if 1
  static constexpr bool operator()(int i, int j)
#else
  constexpr bool operator()(int i, int j)
#endif
  {
    return i < j;
  }
};

int main()
{
  static_assert(Foo::operator()(1, 2));
}
