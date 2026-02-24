#include <fstream>
#include <iostream>
#include <string>
#include <unordered_map>
#include <vector>

using Stone = unsigned long long;
using Count = unsigned long long;
using Record = std::unordered_map<Stone, Count>;
using Stones = std::vector<Stone>;

Stones transform(Stone s) {
  if (s == 0)
    return {1};

  std::string str = std::to_string(s);

  if (str.size() % 2 == 0) {
    auto half = str.size() / 2;
    auto s1 = str.substr(0, half);
    auto s2 = str.substr(half);
    return {(Stone)std::atoll(s1.c_str()), (Stone)std::atoll(s2.c_str())};
  }

  return {s * 2024};
}

Record blink(const Record &rec) {
  Record new_stones;
  for (auto &pair : rec) {
    auto stone = pair.first;
    auto count = pair.second;
    auto generated = transform(stone);
    for (auto ns : generated) {
      new_stones[ns] += count;
    }
  }
  return new_stones;
}

Count count(const Record &rec) {
  Count s = 0;
  for (auto &pair : rec) {
    s += pair.second;
  }
  return s;
}

int main(int argc, char **argv) {
  std::fstream file(argv[1]);
  Record rec;
  std::string s;
  while (file >> s) {
    rec[(Stone)std::atoll(s.c_str())] += 1;
  }
  for (int i = 0; i < 75; i++) {
    rec = blink(rec);
  }
  std::cout << count(rec) << "\n";
}
