#include <iostream>

using Result = long long;
using Input = int;

Result power(Input x, Input n) { return n == 0 ? 1 : x * power(x, n - 1); }

Result quick_power(Input x, Input n) {
  if (n == 0) {
    return 1;
  }
  Result r = quick_power(x, n / 2);
  return n % 2 == 0 ? r * r : x * r * r;
}

Result better_quick_power(Input x, Input n, Input acc = 1) {
  if (n == 0)
    return acc;
  if (n == 1)
    return x * acc;
  if (n % 2 == 0)
    return better_quick_power(x * x, n / 2, acc);
  return better_quick_power(x * x, n / 2, acc * x);
}

int main() {
  std::cout << power(2, 10) << "\n";
  std::cout << quick_power(2, 9) << "\n";
  std::cout << better_quick_power(2, 9) << "\n";
  std::cout << better_quick_power(2, 10) << "\n";
}
