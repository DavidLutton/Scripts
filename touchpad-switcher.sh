#!/bin/bash

#xinput set-prop 10 "Device Enabled" 0
function touchpad(){
        device="Synaptics TouchPad"
        vice=$( xinput | grep "Synaptics TouchPad"  | awk '{ print $6 }' | cut $

        status=$( xinput list-props $vice | grep "Device Enabled" | awk '{ prin$

        echo -e "The $device,$vice is $status \nn of next state"

        read state
        # if 0 or 1 pass to set-prop
        if [ "$state" = "0" ] || [ "$state" = "1" ]
        then
                xinput set-prop $vice "Device Enabled" $state
        fi
}
