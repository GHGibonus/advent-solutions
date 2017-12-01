day=$1
puzzle=$2
week=$((day / 7 + 1))
echo "week$week/D${day}_${puzzle}"*
xsel -b | "week$week/D${day}_${puzzle}"*
