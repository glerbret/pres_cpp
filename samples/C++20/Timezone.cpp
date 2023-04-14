#include <iostream>
#include <chrono>
#include <format>

using namespace std::literals::chrono_literals;

int main()
{
  auto tp = std::chrono::sys_days{2016y/std::chrono::May/29d} + 7h + 30min + 6s + 153ms; 
  std::chrono::zoned_time zt = {"Asia/Tokyo", tp};

  std::cout << std::format("{:%F %T}", tp) << "\n";
  std::cout << std::format("{:%F %T}", zt) << "\n";
}
