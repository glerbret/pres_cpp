#include <iostream>
#include <string>

struct Foo
{
  operator int()
  {
    return 5;
  }
};


struct Bar
{
  explicit operator int()
  {
    return 5;
  }
};

int main()
{
  {
    Foo f;
    int a = f;
    int b = static_cast<int>(f);
    std::cout << a << ' ' << b << '\n';
  }

  {
    Bar f;
#if 1
    int a = f;
#endif
    int b = static_cast<int>(f);
    std::cout << b << '\n';
  }
}
