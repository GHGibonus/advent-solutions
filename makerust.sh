day=$1
puzzle=$2
week=$(((day + 3)/ 7 + 1))
rustsrc=$(ls "complement/D${day}_${puzzle}"*)
rustc -O $rustsrc -o "week${week}/${rustsrc##*/}"
echo rustc -O $rustsrc -o "week${week}/${rustsrc##*/}"
