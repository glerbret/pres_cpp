#include <iostream>
#include <string_view>
#include <source_location>
 
void log(const std::string_view& message, const std::source_location& location = std::source_location::current())
{
  std::cout << location.file_name() << ":"
            << location.line() << " "
            << location.function_name() << " "
            << message << '\n';
}
 
int main()
{
  log("Hello world!");
}
