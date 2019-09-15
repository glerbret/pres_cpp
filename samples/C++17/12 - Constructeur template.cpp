#include <iostream>
#include <tuple>
#include <utility>

template<class Func> struct Foo
{
  Foo(Func f) : func(f)
  {
  }

  void operator() (int i)
  {
    func(i);
  }

  Func func;
};

int main()
{
  {
    std::pair p(2, 4.5);
    std::tuple t(4, 3, 2.5);
  }

  {
    int a = 2;

    Foo foo([&](int i) {std::cout << a * i << '\n';});

    foo(5);
  }
}
