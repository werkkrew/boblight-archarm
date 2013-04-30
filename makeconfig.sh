#!/bin/bash

# Modified by werkkrew from original code found: https://code.google.com/p/boblight/issues/detail?id=24
# Changed script to limit light names to 3 characters to work with the Speedy1985 enhancements.

echo -n "What is the depth that the hscan and vscan should look into the screen? [13] "
read depth

echo -n "What is the device name? [ambilight] "
read devicename

echo -n "What is the color order of your LED's (e.g. BRG, RGB, GRB)?  [RGB] "
read rgborder

echo -n "How many lights on the Left side? [0] "
read left

echo -n "How many lights on the Top? [0] "
read top

echo -n "How many lights on the Right side? [0] "
read right

echo -n "How many lights on the Bottom? [0] "
read bottom

# Set the defaults
left=${left:-0}
top=${top:-0}
right=${right:-0}
bottom=${bottom:-0}
devicename=${devicename:-ambilight}
depth=${depth:-13}
rgborder=${rgborder:-RGB}

total=$(expr $left + $top + $right + $bottom)

echo "Total light: $total"

if [ "$rgborder" == "RGB" ]; then
	declare -a ledcolor=(red green blue)
elif [ "$rgborder" == "BRG" ]; then
	declare -a ledcolor=(blue red green)
elif [ $rgborder == "GRB" ]; then
	declare -a ledcolor=(green red blue)
else
	declare -a ledcolor=(red green blue)	
fi

echo
echo "------- Light section starts here ------"

current=1
colorcount=1


if [ $bottom -ne 0 ]; then
        bcount=1
        brange=$(echo "scale=2; 100 / $bottom" | bc)
        bcurrent=50

        while [ $bcount -le $(expr $bottom / 2 2>/dev/null) ]; do
                btop=$(echo "scale=2; $bcurrent - $brange" | bc)

                echo
                echo "[light]"
		printf "%-20s B%02d\n" "name" $bcount
		printf "%-20s %-5s %12s %d\n" "color" "${ledcolor[0]}" "$devicename" $colorcount
                ((colorcount++))
		printf "%-20s %-5s %12s %d\n" "color" "${ledcolor[1]}" "$devicename" $colorcount
                ((colorcount++))
		printf "%-20s %-5s %12s %d\n" "color" "${ledcolor[2]}" "$devicename" $colorcount
                ((colorcount++))

		printf "%-20s %3.2f %3.2f\n" "hscan" $btop $bcurrent
		printf "%-20s %3.2f %3.2f\n" "vscan" $(echo "scale=2; 100 - $depth" | bc) 100

                bcurrent=$btop

                ((bcount++))
                ((current++))
        done
fi

if [ $left -ne 0 ]; then
        lcount=1
        lrange=$(echo "scale=2; 100 / $left" | bc)
        lcurrent=100

        while [ $lcount -le $left ]; do
                ltop=$(echo "scale=2; $lcurrent - $lrange" | bc)
                
                echo
                echo "[light]"
                printf "%-20s L%02d\n" "name" $lcount
                printf "%-20s %-5s %12s %d\n" "color" "${ledcolor[0]}" "$devicename" $colorcount
                ((colorcount++))
                printf "%-20s %-5s %12s %d\n" "color" "${ledcolor[1]}" "$devicename" $colorcount
                ((colorcount++))
                printf "%-20s %-5s %12s %d\n" "color" "${ledcolor[2]}" "$devicename" $colorcount
                ((colorcount++))

                printf "%-20s %3.2f %3.2f\n" "hscan" 0 $depth 
                printf "%-20s %3.2f %3.2f\n" "vscan" $ltop $lcurrent

                lcurrent=$ltop

                ((lcount++))
                ((current++))
        done
fi


if [ $top -ne 0 ]; then
        tcount=1
        trange=$(echo "scale=2; 100 / $top" | bc)
        tcurrent=0

        while [ $tcount -le $top ]; do
                ttop=$(echo "scale=2; $tcurrent + $trange" | bc)

                echo
                echo "[light]"
		printf "%-20s T%02d\n" "name" $tcount
                printf "%-20s %-5s %12s %d\n" "color" "${ledcolor[0]}" "$devicename" $colorcount
                ((colorcount++))
                printf "%-20s %-5s %12s %d\n" "color" "${ledcolor[1]}" "$devicename" $colorcount
                ((colorcount++))
                printf "%-20s %-5s %12s %d\n" "color" "${ledcolor[2]}" "$devicename" $colorcount
                ((colorcount++))

                printf "%-20s %3.2f %3.2f\n" "hscan" $tcurrent $ttop
                printf "%-20s %3.2f %3.2f\n" "vscan" 0 $depth

                tcurrent=$ttop

                ((tcount++))
                ((current++))
        done
fi

if [ $right -ne 0 ]; then
        rcount=1
        rrange=$(echo "scale=2; 100 / $right" | bc)
        rcurrent=0

        while [ $rcount -le $right ]; do
                rtop=$(echo "scale=2; $rcurrent + $rrange" | bc)

                echo
                echo "[light]"
                printf "%-20s R%02d\n" "name" $rcount
                printf "%-20s %-5s %12s %d\n" "color" "${ledcolor[0]}" "$devicename" $colorcount
                ((colorcount++))
                printf "%-20s %-5s %12s %d\n" "color" "${ledcolor[1]}" "$devicename" $colorcount
                ((colorcount++))
                printf "%-20s %-5s %12s %d\n" "color" "${ledcolor[2]}" "$devicename" $colorcount
                ((colorcount++))

                printf "%-20s %3.2f %3.2f\n" "hscan" $(echo "scale=2; 100 - $depth" | bc) 100
                printf "%-20s %3.2f %3.2f\n" "vscan" $rcurrent $rtop

                rcurrent=$rtop

                ((rcount++))
                ((current++))
        done
fi


if [ $bottom -ne 0 ]; then
        bcurrent=100

        while [ $bcount -le $bottom ]; do
                btop=$(echo "scale=2; $bcurrent - $brange" | bc)

                echo
                echo "[light]"
                printf "%-20s B%02d\n" "name" $rcount
                printf "%-20s %-5s %12s %d\n" "color" "${ledcolor[0]}" "$devicename" $colorcount
                ((colorcount++))
                printf "%-20s %-5s %12s %d\n" "color" "${ledcolor[1]}" "$devicename" $colorcount
                ((colorcount++))
                printf "%-20s %-5s %12s %d\n" "color" "${ledcolor[2]}" "$devicename" $colorcount
                ((colorcount++))

                printf "%-20s %3.2f %3.2f\n" "hscan" $btop $bcurrent
                printf "%-20s %3.2f %3.2f\n" "vscan" $(echo "scale=2; 100 - $depth" | bc) 100

                bcurrent=$btop

                ((bcount++))
                ((current++))
        done
fi

echo
echo "------- Light section ends here ------"
