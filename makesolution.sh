day=$1
puzzle=$2
if [ $day = 15 ] ; then
	echo Please, compile first using ghc and then run the code.
	echo Without optimisation, the haskell implementation will
	echo summon the OOM reaper.
	exit 1
fi
week=$(((day + 3)/ 7 + 1))
echo "week$week/D${day}_${puzzle}"*
xsel -b | "week$week/D${day}_${puzzle}"*
