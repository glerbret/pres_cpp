#include <iostream>

enum class Foo : unsigned int
{
  Invalid = 0,
};

int main()
{
  Foo foo{42};
  Foo bar = Foo{42};

  std::cout << static_cast<unsigned int>(foo) << "\n";
  std::cout << static_cast<unsigned int>(bar) << "\n";

#if 0
  Foo baz;
  baz = 42;
#endif

#if 0
  Foo baz = 42;
#endif

#if 0
  Foo baz = {42};
#endif
}
