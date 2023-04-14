#include <iostream>
#include <chrono>
#include <format>

using namespace std::literals::chrono_literals;

int main()
{
  auto date1 = 2016y/std::chrono::May/29d;
  auto date2 = std::chrono::Sunday[3]/std::chrono::May/2016y;

  std::cout << std::format("{:%F}", date1) << "\n";
  std::cout << std::format("{:%F}", date2) << "\n";
}
