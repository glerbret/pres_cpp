#include <iostream>

[[ deprecated("Utilisez Foo") ]]
static void bar()
{
}

class [[ deprecated ]] Baz
{
};

int main()
{
  bar();

  Baz baz;

  [[ deprecated ]]
  int foo{42};
  std::cout << foo << '\n';
}
