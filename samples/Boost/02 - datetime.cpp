#include <iostream>
#include <boost/date_time/posix_time/posix_time.hpp>
#include <boost/date_time/gregorian/gregorian.hpp>

int main()
{
  boost::posix_time::ptime localDate = boost::posix_time::second_clock::local_time();
  boost::posix_time::ptime utcDate = boost::posix_time::second_clock::universal_time();
  boost::posix_time::ptime fixedDate = boost::posix_time::time_from_string("2002-01-01 10:00:01.123456789");

  std::cout << boost::posix_time::to_simple_string(localDate) << '\n';
  std::cout << boost::posix_time::to_simple_string(utcDate) << '\n';
  std::cout << boost::posix_time::to_simple_string(fixedDate) << '\n';

  std::cout << localDate.date().year() << ' ';
  std::cout << localDate.date().month() << ' ';
  std::cout << localDate.date().day() << ' ';
  std::cout << localDate.date().day_of_week() << ' ';
  std::cout << localDate.date().day_of_year() << ' ';
  std::cout << localDate.date().week_number() << ' ';
  std::cout << localDate.time_of_day().hours() << ' ';
  std::cout << localDate.time_of_day().minutes() << ' ';
  std::cout << localDate.time_of_day().seconds() << '\n';

  localDate += (boost::posix_time::hours(1) + boost::posix_time::minutes(2));
  localDate -= boost::gregorian::days(1);
  std::cout << boost::posix_time::to_simple_string(localDate) << '\n';

  std::cout << (localDate - fixedDate).hours() << '\n';
}
