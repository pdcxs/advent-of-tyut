#include <iostream>
#include <map>
#include <string>
#include <tuple>
#include <vector>

using Index = int;
using Input = std::tuple<Index, Index>;

using Output = size_t;
using Record = std::map<Input, Output>;

Output lcm_helper(const std::string &s1, const std::string &s2, Index i,
                  Index j, Record &rcd) {
  if (i < 0 || j < 0)
    return 0;

  Input input = std::make_tuple(i, j);
  if (rcd.find(input) != rcd.end()) {
    return rcd[input];
  }

  if (s1[i] == s2[j]) {
    Output r = lcm_helper(s1, s2, i - 1, j - 1, rcd) + 1;
    rcd[input] = r;
    return r;
  }

  Output r = std::max(lcm_helper(s1, s2, i - 1, j, rcd),
                      lcm_helper(s1, s2, i, j - 1, rcd));
  rcd[input] = r;
  return r;
}

Output lcm(const std::string &s1, const std::string &s2) {
  Record rcd;
  return lcm_helper(s1, s2, s1.size() - 1, s2.size() - 1, rcd);
}

using std::string;
using std::vector;

Output better_lcm(const string &s1, const string &s2) {
  size_t n1 = s1.size();
  size_t n2 = s2.size();

  vector<vector<Output>> rec(n1 + 1, vector<Output>(n2 + 1, 0));

  for (size_t i = 1; i <= n1; i++) {
    for (size_t j = 1; j <= n2; j++) {
      if (s1[i - 1] == s2[j - 1]) {
        rec[i][j] = rec[i - 1][j - 1] + 1;
      } else {
        rec[i][j] = std::max(rec[i][j - 1], rec[i - 1][j]);
      }
    }
  }
  return rec[n1][n2];
}

int main() {
  std::cout
      << better_lcm(
             "fcvafurqjylclorwfoladwfqzkbebslwnmpmlkbezkxoncvwhstwzwpqxqtyxozkp"
             "gtgtsjobujezgrkvevklmludgtyrmjaxyputqbyxqvupojutsjwlwluzsbmvyxifq"
             "tglwvcnkfsfglwjwrmtyxmdgjifyjwrsnenuvsdedsbqdovwzsdghclcdexmtsbex"
             "wrszihcpibwpidixmpmxshwzmjgtadmtkxqfkrsdqjcrmxkbkfoncrcvoxuvcdyta"
             "jgfwrcxivixanuzerebuzklyhezevonqdsrkzetsrgfgxibqpmfuxcrinetyzkvud"
             "ghgrytsvwzkjulmhanankxqfihenuhmfsfkfepibkjmzybmlkzozmluvybyzslelu"
             "dsxkpinizoraxonmhwtkfkhudizepyzijafqlepcbihofepmjqtgrsxorunshgpaz"
             "ovuhktatmlcfklafivivefyfubunszyvarcrkpsnglkduzaxqrerkvcnmrurkhkpa"
             "rgvcxefovwtapedaluhclmzynebczodwropwdenqxmrutuhehadyfspcpuxyzodif"
             "qdqzgbwhodcjonypyjwbwxepcpujerkrelunstebopkncdazexsbezmhynizsvara"
             "fwfmnclerafejgnizcbsrcvcnwrolofyzulcxaxqjqzunedidulspslebifinqrch"
             "yvapkzmzwbwjgbyrqhqpolwjijmzyduzerqnadapudmrazmzadstozytonuzarizs"
             "zubkzkhenaxivytmjqjgvgzwpgxefatetoncjgjsdilmvgtgpgbibexwnexstipkj"
             "ylalqnupexytkradwxmlmhsnmzuxcdkfkxyfgrmfqtajatgjctenqhkvyrgvapctq"
             "tyrufcdobibizihuhsrsterozotytubefutaxcjarknynetipehoduxyjstufwvkv"
             "wvwnuletybmrczgtmxctuny",
             "nohgdazargvalupetizezqpklktojqtqdivcpsfgjopaxwbkvujilqbclehulatsh"
             "ehmjqhyfkpcfwxovajkvankjkvevgdovazmbgtqfwvejczsnmbchkdibstklkxarw"
             "jqbqxwvixavkhylqvghqpifijohudenozotejoxavkfkzcdqnoxydynavwdylwhat"
             "slyrwlejwdwrmpevmtwpahatwlaxmjmdgrebmfyngdcbmbgjcvqpcbadujkxaxuju"
             "dmbejcrevuvcdobolcbstifedcvmngnqhudixgzktcdqngxmruhcxqxypwhahobud"
             "elivgvynefkjqdyvalmvudcdivmhghqrelurodwdsvuzmjixgdexonwjczghalsjo"
             "pixsrwjixuzmjgxydqnipelgrivkzkxgjchibgnqbknstspujwdydszohqjsfuzst"
             "yjgnwhsrebmlwzkzijgnmnczmrehspihspyfedabotwvwxwpspypctizyhcxypqzc"
             "twlspszonsrmnyvmhsvqtkbyhmhwjmvazaviruzqxmbczaxmtqjexmdudypovkjkl"
             "ynktahupanujylylgrajozobsbwpwtohkfsxeverqxylwdwtojoxydepybavwhgde"
             "hafurqtcxqhuhkdwxkdojipolctcvcrsvczcxedglgrejerqdgrsvsxgjodajatsn"
             "ixutihwpivihadqdotsvyrkxehodybapwlsjexixgponcxifijchejoxgxebmbclc"
             "zqvkfuzgxsbshqvgfcraxytaxeviryhexmvqjybizivyjanwxmpojgxgbyhcruvqp"
             "afwjslkbohqlknkdqjixsfsdurgbsvclmrcrcnulinqvcdqhcvwdaxgvafwravunu"
             "rqvizqtozuxinytafopmhchmxsxgfanetmdcjalmrolejidylkjktunqhkxchyjmp"
             "kvsfgnybsjedmzkrkhwryzan")
      << "\n";
}
