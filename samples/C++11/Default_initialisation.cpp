#include <iostream>

struct Foo
{
  Foo()
  {}

  int m_a{2};
};

int main()
{
  Foo foo;

  std::cout << foo.m_a << '\n';
}
