#include <iostream>
#include <string>

struct Foo
{
  Foo(int a)
    : m_a(a)
  {
  }

  Foo(const std::string& str)
    : m_a(std::stoi(str))
  {
  }

  int m_a;
};

struct Bar : Foo
{
  using Foo::Foo;

};

struct Baz : Foo
{
  using Foo::Foo;

  Baz(const std::string& str)
    : Foo(0)
    , m_str(str)
  {
  }


  std::string m_str;
};

int main()
{
  {
    Foo foo(4);
    Foo bar("42");

    std::cout << foo.m_a << ' ' << bar.m_a << '\n';
  }

  {
    Bar foo(4);
    Bar bar("42");

    std::cout << foo.m_a << ' ' << bar.m_a << '\n';
  }

  {
    Baz foo(4);
    Baz bar("42");

    std::cout << foo.m_a << ' ' << bar.m_a << ' '<< bar.m_str <<'\n';
  }
}
