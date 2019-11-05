#!/bin/bash

# Usage: ./tinder-liker.sh [-c X Y] [-d delay]
# -c Define X Y coordinates
# -d Define delay between likes (default delay recommended)

function setModel() {
	MODEL=$(adb devices -l | grep -m 1 -i device: | sed -E 's/.*model:(.*?) device.*/\1/')
}

function setDetectedModelCoordinates() {
	case $MODEL in
	    OnePlus7Pro)
			X=750
			Y=1600;;
		Mi_MIX_2)
			X=500
	        Y=1000;;				
	    *)
			echo "Unknown model $1"
	        exit 3
	esac
}

# Default delay
DELAY=0.5

# Get params
while [ "$1" != "" ]; do
    case $1 in
        -c)
			shift
            X=$1
            shift
            Y=$1;;
        -d)
			shift
            DELAY=$1;;
        -m)
			shift
			MODEL=$1;;
        *)
			echo "Unknown parameter $1"
            exit 1
    esac
    shift
done

# If no model specified, then check coordinates
# If model specified, then check and assign coordinates for model

if [ -z "$X" ] || [ -z "$Y" ]
then
	echo "No coordinates specified, attempting to detect model..."
	setModel
	setDetectedModelCoordinates
fi

echo "Coordinates set to $X $Y"

# Swipe like forever
echo "Swiping... (Ctrl-C to stop)"
while true; do
	END_X=$((X + 400))
	adb shell input touchscreen swipe $X $Y $END_X $Y
	sleep "$DELAY";
done
exit 0
