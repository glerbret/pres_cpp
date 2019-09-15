#include <iostream>
#include <string>

struct Foo
{
  Foo()
  {
  }

  virtual void f(int)
  {
  }
};

struct Bar : Foo
{
  Bar()
  {
  }

  virtual void f(int) final
  {
  }
};

struct Baz : Bar
{
  Baz()
  {
  }

  virtual void f(int)
  {
  }
};

int main()
{
}
