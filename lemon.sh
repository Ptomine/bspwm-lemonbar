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
	 #sed -n 'N;s/^.*\[\([0-9]\+%\).*$/\1/p'
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
    # read lo int1 int2 <<< `ip link | sed -n 's/^[0-9]: \(.*\):.*$/\1/p'`
	ip link show wlp3s0 | grep 'state UP' >/dev/null && (ping -c 1 8.8.8.8 >/dev/null 2>&1 && echo "" || echo "disconnected") || (ip link show enp0s25 | grep 'state UP' >/dev/null && (ping -c 1 8.8.8.8 >/dev/null 2>&1 && echo "" || echo "disconnected"))
    # if iwconfig $int1 >/dev/null 2>&1; then
        # wifi=$int1
        # eth0=$int2
    # else
        # wifi=$int2
        # eth0=$int1
    # fi
    # ip link show $eth0 | grep 'state UP' >/dev/null && (ping -c 1 8.8.8.8 >/dev/null 2>&1 && echo "$int " || echo "$int disconnected") || (ping -c 1 8.8.8.8 >/dev/null 2>&1 && echo "$int " || echo "$int disconnected")

    #int=eth0

    # ping -c 1 8.8.8.8 >/dev/null 2>&1 && 
        # echo "$int " || echo "$int "
}

groups() {
    cur=`xprop -root _NET_CURRENT_DESKTOP | awk '{print $3}'`
    tot=`xprop -root _NET_NUMBER_OF_DESKTOPS | awk '{print $3}'`

    for w in `seq 0 $((cur - 1))`; do line="${line}"; done
    line="${line}"
    for w in `seq $((cur + 2)) $tot`; do line="${line}"; done
    echo $line
}

while :; do
	buf="%{l}"
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