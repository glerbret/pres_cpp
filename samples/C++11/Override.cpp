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

  virtual void g(int) const
  {
  }

  void h(int)
  {
  }
};

struct Bar : Foo
{
  Bar()
  {
  }

  void f(float) override
  {
  }

  void g(int) override
  {
  }

  void h(int) override
  {
  }

  void i(int) override
  {
  }
};

int main()
{
}
