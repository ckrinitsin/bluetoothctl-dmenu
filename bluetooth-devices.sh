#
# This program lists all paired devices which you can select from, the selected one
# will be connected
#   

# Opens dmenu prompt, which lets you decide which device you want to connect to
DEVICE=$(bluetoothctl devices | sed 's/[^ ]* //' | sed 's/[^ ]* //' | dmenu -i)

# If dmenu was cancelled, exit program
if [ $? -ne 0 ]; then
    exit 1
fi

# Get MAC adress of the device you selected
MAC=$(bluetoothctl devices | grep "$DEVICE" | sed 's/[^ ]* //' | cut -d ' ' -f1)

# If bluetooth device is already connected, disconnect
CONNECTED=$(bluetoothctl devices Connected | cut -f3 -d ' ')
if echo $CONNECTED | grep $DEVICE; then
    if bluetoothctl disconnect $MAC | grep -q 'successful' 
    then
        notify-send -t 5000 -r 2954 -u normal "  Disconnected successfully from" "     $DEVICE"
    else 
        notify-send -t 5000 -r 2954 -u normal "  Couldn't disconnect from" "     $DEVICE"
    fi 
    exit 0
fi

# Send a notify whether the connection was successful 
if bluetoothctl connect $MAC | grep -q 'successful' 
then
    notify-send -t 5000 -r 2954 -u normal "  Connected successfully to" "     $DEVICE"
else 
    notify-send -t 5000 -r 2954 -u normal "  Couldn't connect to" "     $DEVICE"
fi
