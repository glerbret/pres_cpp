#include <iostream>
#include <chrono>


int main()
{
  {
    std::chrono::milliseconds foo(12000);
    std::cout << foo.count() << '\n';
    std::cout << foo.count() * std::chrono::milliseconds::period::num / std::chrono::milliseconds::period::den << '\n';
  }

  {
    std::chrono::milliseconds foo(500);
    std::chrono::milliseconds bar(10);

    foo += bar;
    std::cout << foo.count() << '\n';

    foo /= 2;
    std::cout << foo.count() << '\n';
  }

  {
    std::chrono::system_clock::time_point t = std::chrono::system_clock::now();
    std::cout << t.time_since_epoch().count() << '\n';
  }
}
