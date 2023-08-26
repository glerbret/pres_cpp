#include <stacktrace>
#include <iostream>

void foo()
{
  auto trace = std::stacktrace::current();
  for (const auto& entry: trace)
  {
    std::cout << "Description: " << entry.description() << "\n";
    std::cout << "file: " << entry.source_file() << "\n";
    std::cout << "line: " << entry.source_line() << "\n";
    std::cout << "------------------------------------" << "\n";
  }
}

int main()
{
  foo();
}
