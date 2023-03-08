external_monitor=$(xrandr --query | grep 'DVI-I-1-1')
if [[ $external_monitor = *connected* ]]; then
	#$(xrandr --listproviders | grep -q "modesetting") && xrandr --setprovideroutputsource 1 0
	#~/.screenlayout/.office.sh
	autorandr --change
	sleep 5
	bspc monitor eDP1 -d 1 2 3 4 5
	bspc monitor DVI-I-1-1 -d 6 7 8 9 0
	feh --bg-fill ~/Downloads/wallhaven-737120.jpg
fi
