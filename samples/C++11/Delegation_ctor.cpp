#include <iostream>

class Foo
{
public:
  Foo(int a)
    : m_a(a)
  {
  }

  Foo()
    : Foo(2)
  {
  }

  void print()
  {
    std::cout << m_a << '\n';
  }

private:
  int m_a;
};

int main()
{
  Foo foo(4);
  Foo bar;

  foo.print();
  bar.print();
}
