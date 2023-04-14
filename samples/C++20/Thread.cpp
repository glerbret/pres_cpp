#include <iostream>
#include <thread>

void foo()
{
  std::cout << "Foo\n";
}

int main()
{
#if 1
  std::jthread t(foo);
#else
  std::thread t(foo);
#endif
}
