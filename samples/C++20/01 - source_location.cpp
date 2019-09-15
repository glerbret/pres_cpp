#include <iostream>
#include <string_view>

// Version experimental car pas de compilateur en version definitive
#include <experimental/source_location>
 
void log(const std::string_view& message, const std::experimental::source_location& location = std::experimental::source_location::current())
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
