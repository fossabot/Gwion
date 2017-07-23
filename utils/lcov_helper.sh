#!/bin/bash
OUTFILE=lcov/lcov.info
#make all

#source utils/test.sh
[ -d lcov ] || mkdir lcov

#do_test severity=11 ASYNC=0 tests/sh/ examples tests/error tests/tree tests/bug tests/ugen_coverage | consummer

[ -z "$TRAVIS_BUILD_DIR" ] || source utils/test.sh; do_test "tests/bug"

#lcov --no-external --capture --directory core --directory lang --directory ugen --output-file "$OUTFILE"
lcov --capture --directory src --output-file "$OUTFILE"

[ -z "$TRAVIS_BUILD_DIR" ] || {
  coveralls-lcov lcov/lcov.info
  exit
}

genhtml -q -s -t "Gwion: coverage" -o "$OUTFILE" --precision 2

cat << EOF > lcov/helper_gcov.js
var i = 1;
var cusid_ele = document.getElementsByClassName('LineNoCov');
function keyDownTextField(e) {
var keyCode = e.keyCode;
  if(keyCode==78) {
    var item = cusid_ele[i];
    cusid_ele[i].scrollIntoView();
    i++;
  } else if(keyCode==66){
    i--;
    var item = cusid_ele[i];
    cusid_ele[i].scrollIntoView();
  }
  if(i < 1) i = 1;
  var size = cusid_ele.length - 1;
  if(i > size) i = size;
}
document.addEventListener("keydown", keyDownTextField, false);
EOF

cat << EOF > lcov/helper_func.js
var i = 1;
var cusid_ele = document.getElementsByClassName('coverFnLo');
function keyDownTextField(e) {
var keyCode = e.keyCode;
  if(keyCode==78) {
    var item = cusid_ele[i];
    cusid_ele[i].scrollIntoView();
    i++;
  } else if(keyCode==66){
    i--;
    var item = cusid_ele[i];
    cusid_ele[i].scrollIntoView();
  }
  if(i < 1) i = 1;
  var size = cusid_ele.length - 1;
  if(i > size) i = size;
}
document.addEventListener("keydown", keyDownTextField, false);
EOF

for file in lcov/*/*.c.gcov.html
do sed -i 's/<body>/<body><script src="..\/helper_gcov.js"><\/script>/' "$file"
done

for file in lcov/*/*.*.func*.html
do sed -i 's/<body>/<body><script src="..\/helper_func.js"><\/script>/' "$file"
done
