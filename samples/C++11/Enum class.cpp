#include <iostream>
#include <type_traits>

enum class Foo : unsigned int
{ 
  BAR1,
  BAR2,
};

int main()
{
#if 0
  Foo foo = BAR2;
#else
  Foo foo = Foo::BAR2;
#endif

#if 0
  std::cout << foo << "\n";
#else
  std::cout << static_cast<std::underlying_type<Foo>::type>(foo) << "\n";
#endif
}
