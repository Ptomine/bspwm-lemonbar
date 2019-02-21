#!/bin/bash
clock() {
	date '+%H:%M'
}

battery() {
	BATC=/sys/class/power_supply/BAT0/capacity
	BATS=/sys/class/power_supply/BAT0/status
	test "`cat $BATS`" = "Charging" && echo -n '' || (test `cat $BATC` -le 5 && echo -n '' || (test `cat $BATC` -le 25 && echo -n '' || (test `cat $BATC` -le 50 && echo -n '' || (test `cat $BATC` -le 75 && echo -n '' || echo -n ''))))
	sed -n p $BATC
}

volume() {
	amixer get Master | grep 'off' >/dev/null && echo "muted" || amixer get Master | grep -w 'Mono' | awk '{print$4}'
}

cpuload() {
	LINE=`ps -eo pcpu |grep -vE '^\s*(0.0|%CPU)' |sed -n '1h;$!H;$g;s/\n/ +/gp'`
	bc <<< $LINE
}

memused() {
	f=$(grep -E 'MemFree' /proc/meminfo |awk '{print $2}')
	t=$(grep -E 'MemTotal' /proc/meminfo |awk '{print $2}')
    bc <<< "scale=2; 100 -  $f/$t  * 100" | cut -d. -f1
}

network() {
	ip link show wlp3s0 | grep 'state UP' >/dev/null && (ping -c 1 8.8.8.8 >/dev/null 2>&1 && echo "" || echo "disconnected") || (ip link show enp0s25 | grep 'state UP' >/dev/null && (ping -c 1 8.8.8.8 >/dev/null 2>&1 && echo "" || echo "disconnected"))
}

get_app_icon() {
	if [[ ${1} == "\"sublime_text\"" ]] || [[ ${1} == "\"libreoffice-writer\"" ]]; then
        echo ""
	elif [[ ${1} == "\"URxvt\"" ]] ; then
	   echo ""
	elif [[ ${1} == "\"Vimb\"" ]] ; then
	   echo ""
	elif [[ ${1} == "\"TelegramDesktop\"" ]] ; then
	   echo ""
    elif [[ ${1} == "\"jetbrains-clion\"" ]] || [[ ${1} == "\"jetbrains-pycharm\"" ]] || [[ ${1} == "\"jetbrains-rider\"" ]] || [[ ${1} == "\"jetbrains-idea-ce\"" ]]; then
        echo ""
    elif [[ ${1} == "\"Pcmanfm\"" ]] ; then
        echo ""
	else
	   echo ""
	fi	
}

groups() {
    cur=`xprop -root _NET_CURRENT_DESKTOP | awk '{print $3}'`
    tot=`xprop -root _NET_NUMBER_OF_DESKTOPS | awk '{print $3}'`

    for win_id in $( wmctrl -l | cut -d' ' -f1 ); do
    	dt=`xprop -id $win_id _NET_WM_DESKTOP | awk '{print $3}'`
    	class=`xprop -id $win_id WM_CLASS | cut -d" " -f4-`
    	apps[$dt]="${apps[$dt]}$(get_app_icon ${class})"
    done

    for w in `seq 0 $((cur - 1))` ; do
    	if [ -z ${apps[$w]} ] ; then
    		line="${line}        ."
    	else
    		line="${line}    ${apps[$w]}    ."
    	fi
    done

    if [ -z ${apps[$cur]} ] ; then
    	line="${line}%{B#BE005577}%{+u}        %{B#22000000}%{-u}"
    else
    	line="${line}%{B#BE005577}%{+u}    ${apps[$cur]}    %{B#22000000}%{-u}"
    fi

    for w in `seq $((cur + 1)) $((tot - 1))` ; do
    	if [ -z ${apps[$w]} ] ; then
    		line="${line}.        "
    	else
    		line="${line}.    ${apps[$w]}    "
    	fi
    done

    unset apps
    echo $line
}

while :; do
	buf="%{l}%{B#22000000}%{-u}"
	buf="${buf} $(groups)   %{c}  "
	buf="${buf} $(clock) %{r}"
	buf="${buf} : $(volume)  "
	buf="${buf} CPU: $(cpuload)%  "
	buf="${buf}  $(memused)%"
	buf="${buf} $(network) "	
	buf="${buf} $(battery)% "

	echo $buf
	sleep 1
done
