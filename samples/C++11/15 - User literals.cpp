#include <iostream>
#include <string>

class Foo
{
public:
  explicit Foo(int a)
    : m_a{a}
  {}

  void print()
  {
    std::cout << m_a << '\n';
  }

private :
  int m_a;
};

static Foo operator "" _f(unsigned long long int a)
{
  return Foo(a);
}

static Foo operator""_f(const char* str, size_t /* length */)
{
  return Foo(std::stoull(str));
}

static Foo operator""_b(const char* str)
{
  unsigned long long a = 0;
  for(size_t i = 0; str[i]; ++i)
  {
    a = (a * 2) + (str[i] - '0');
  }
  return Foo(a);
}

int main()
{
  {
#if 0
    Foo foo1 = 12;
#endif
  }

  {
    Foo foo = 42_f;
    foo.print();
  }

  {
    Foo foo = "12"_f;
    foo.print();
  }

  {
    Foo foo = 0110_b;
    foo.print();
  }
}
