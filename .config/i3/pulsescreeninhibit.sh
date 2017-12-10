#!/bin/bash

while : 
do
    if [[ ! -z $(pacmd list-sink-inputs | grep RUNNING) ]] ; then
	echo dpms off	
	xset -dpms
    else
	echo dpms on
        xset +dpms
    fi
    sleep 10
done
