#!/bin/bash

# Default delay
DELAY=0.5

# Get params
while [ "$1" != "" ]; do
    case $1 in
        -x)
			shift
            X=$1;;
        -y)
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
if [ -z "$MODEL" ]; then
	if [ -z "$X" ] || [ -z "$Y" ]
	then
		echo "No model or coordinates specified, exiting"
		exit 2
	fi
else
	setModelCoordinates
fi

# Click like forever
while true; do
	adb shell input tap $X $Y
	sleep "$DELAY";
done
exit 0

# Model to coordinates table
function setModelCoordinates {
	case $MODEL in
	    mi-mix-2)
			X=717
	        Y=2024;;
	    *)
			echo "Unknown model $1"
	        exit 3
	esac
}