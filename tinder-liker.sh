#!/bin/bash

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
        * )
			echo "Unknown parameter $1"
            exit 1
    esac
    shift
done

# Check all params are available
if [ -z "$X" ] || [ -z "$Y" ] || [ -z "$DELAY" ]
then
	echo "Missing parameters"
	exit 2
fi

# Click like forever
while true; do
	adb shell input tap $X $Y
	sleep "$DELAY";
done