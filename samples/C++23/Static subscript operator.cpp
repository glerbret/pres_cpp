#include <iostream>
#include <array>

struct Foo
{
#if 1
  static int operator[](int i)
#else
  int operator[](int i)
#endif
  {
    return v[i];
  }

  static constexpr std::array<int, 4> v{5, 8, 9, 12};
};

int main()
{
  std::cout << Foo::operator[](2) << "\n";
}
