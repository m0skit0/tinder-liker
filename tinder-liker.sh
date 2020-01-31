#!/bin/bash

# Usage: ./tinder-liker.sh [-c X Y] [-d delay] [-g] [-h]
# -h  Shows help and exits (remaining switches are ignored)
# -c  Define X Y coordinates
# -d  Define delay between likes (default delay recommended)
# -t  Use tap instead of swipe
# -g  Go home after Ctrl-C

trap doExit INT

function doExit() {
	if [ ! -z "$GO_HOME" ]
	then
		adb shell input keyevent 3
	fi
	exit 0
}

function setModel() {
	MODEL=$(adb devices -l | grep -m 1 -i device: | sed -E 's/.*model:(.*?) device.*/\1/')
}

function setOnePlus7ProCoordinates() {
	case $MODE in
		swipe)
			X=750
			Y=1600
			OFFSET=600;;
		tap)
			X=970
			Y=2945;;
		*)
			echo "Unknown mode $MODE"
	        exit 4
	esac
}

function setXiaomiMiMix2Coordinates() {
	case $MODE in
		swipe)
			X=500
	        Y=1000
	        OFFSET=500;;
		*)
			echo "Unknown mode $MODE"
	        exit 4
	esac
}

function setDetectedModelCoordinates() {
	case $MODEL in

		# OnePlus 7 Pro
	    GM1913)
			setOnePlus7ProCoordinates;;

		# Xiaomi Mi MIX 2
		Mi_MIX_2)
			X=500
	        Y=1000
	        OFFSET=500;;

	    *)
			echo "Unknown model $1"
	        exit 3
	esac
}

function showHelp() {
	echo " Usage: ./tinder-liker.sh [-c X Y] [-d delay] [-g] [-h]"
	echo -e "\t-h  Shows help and exits (remaining switches are ignored)"
	echo -e "\t-c  Define X Y coordinates (if -t will use it for tapping instead of swipe)"
	echo -e "\t-d  Define delay between likes (default delay recommended)"
	echo -e "\t-t  Use tap instead of swipe"
	echo -e "\t-g  Go home after Ctrl-C"
}

function swipe() {
	END_X=$((X + OFFSET))
	adb shell input touchscreen swipe $X $Y $END_X $Y
}

function tap() {
	adb shell input tap $X $Y
}

DELAY=0
MODE="swipe"

# Get params
while [ "$1" != "" ]; do
    case $1 in
    	-h)
			showHelp
			exit 0;;
        -c)
			shift
            X=$1
            shift
            Y=$1;;
        -d)
			shift
            DELAY=$1;;
        -g)
			GO_HOME="true";;
        -t)
			MODE="tap";;
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

# Launch Tinder
adb shell am start -n com.tinder/.activities.LoginActivity
sleep 5

# Swipe like forever
echo "Liking... (Ctrl-C to stop)"
while true; do
	case $MODE in
	    swipe) 
			swipe;;
		# Xiaomi Mi MIX 2
		tap)
			tap;;				
	    *)
			echo "Unknown mode $MODE"
	        exit 4
	esac
	sleep "$DELAY";
done
exit 0
