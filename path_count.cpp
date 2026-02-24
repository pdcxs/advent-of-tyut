#include <fstream>
#include <iostream>
#include <sstream>
#include <string>
#include <unordered_map>
#include <vector>

using namespace std;

using Node = string;
using Graph = unordered_map<Node, vector<Node>>;
using Count = unsigned long long;
using Record = unordered_map<Node, Count>;

void parse_line(const string &line, Graph &graph) {
  istringstream in(line);
  Node n1;
  in >> n1;
  n1 = n1.substr(0, 3);
  vector<Node> outs;
  Node tmp;
  while (in >> tmp) {
    outs.push_back(tmp);
  }
  graph[n1] = outs;
}

Count count_helper(const Graph &graph, const Node &from, const Node &to,
                   Record &rec) {
  if (from == to)
    return 1;
  if (rec.find(from) != rec.end())
    return rec[from];
  if (graph.find(from) == graph.end())
    return 0;
  auto nexts = graph.at(from);
  Count sum = 0;
  for (const auto &n : nexts) {
    sum += count_helper(graph, n, to, rec);
  }
  rec[from] = sum;
  return sum;
}

Count count(const Graph &graph, const Node &from, const Node &to) {
  Record rec;
  return count_helper(graph, from, to, rec);
}

int main(int argc, char **argv) {
  ifstream file(argv[1]);
  Graph graph;
  string line;
  while (getline(file, line)) {
    parse_line(line, graph);
  }
  Count svr_fft = count(graph, "svr", "fft");
  Count fft_dac = count(graph, "fft", "dac");
  Count dac_out = count(graph, "dac", "out");
  Count svr_dac = count(graph, "svr", "dac");
  Count dac_fft = count(graph, "dac", "fft");
  Count fft_out = count(graph, "fft", "out");
  cout << svr_fft * fft_dac * dac_out + svr_dac * dac_fft * fft_out << "\n";
}
