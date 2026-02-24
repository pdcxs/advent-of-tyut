#include <iostream>
#include <unordered_map>

using Result = unsigned long long;
using Input = unsigned int;
using Record = std::unordered_map<Input, Result>;

Result memo_fib(Input n, Record &rec) {
  if (n < 2) {
    return n;
  }
  if (rec.find(n) != rec.end()) {
    return rec[n];
  }
  Result r = memo_fib(n - 1, rec) + memo_fib(n - 2, rec);
  rec[n] = r;
  return r;
}

int main() {
  Record rec;
  std::cout << memo_fib(50, rec);
}
