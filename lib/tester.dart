
void main(List<String> args) {
  List fl = [1, 2, 3, 4, 5, 6, 7];

  List sl = [];
  int index = 2;

  for(int i = 0; i < fl.length; i++) {
if(i == index) continue;
    sl.add(fl[i]);
  }

  print(sl);
}

