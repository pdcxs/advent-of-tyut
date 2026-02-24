#include <iostream>
#include <map>
#include <tuple>
#include <vector>

using Money = int;
using Coins = std::vector<Money>;
using CoinsNum = size_t;
using Input = std::tuple<Money, CoinsNum>;
using Result = unsigned long long;
using Record = std::map<Input, Result>;

Result solve(Money target, const Coins &coins, CoinsNum n, Record &rec) {
  if (target == 0) {
    return 1;
  }
  if (target < 0 || n <= 0) {
    return 0;
  }

  Input input = std::make_tuple(target, n);
  if (rec.find(input) != rec.end()) {
    return rec[input];
  }
  Money current = coins[n - 1];
  Result r =
      solve(target - current, coins, n, rec) + solve(target, coins, n - 1, rec);
  rec[input] = r;
  return r;
}

int main() {
  Coins coins = {1, 2, 5, 10, 20, 50, 100, 200};
  Record rec;
  std::cout << solve(200, coins, coins.size(), rec);
}
