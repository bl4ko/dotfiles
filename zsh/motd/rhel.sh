#!/bin/bash

USER=`whoami`
HOSTNAME=`uname -n`
ROOT_PART=`df -Ph / | grep / | awk '{print $4}' | tr -d '\n'`
HOME_PART=`df -Ph | grep home | awk '{print $4}' | tr -d '\n'`
BACKUP_PART=`df -Ph | grep backup | awk '{print $4}' | tr -d '\n'`
MNT_PART=`df -Ph | grep mnt | awk '{print $4}' | tr -d '\n'`


MEMORY1=`free -t -m | grep "Mem" | awk '{print $3" MB";}'`
MEMORY2=`free -t -m | grep "Mem" | awk '{print $2" MB";}'`
PSA=`ps -Afl | wc -l`

# time of day
HOUR=$(date +"%H")
if [ $HOUR -lt 12  -a $HOUR -ge 0 ]
then    TIME="morning"
elif [ $HOUR -lt 17 -a $HOUR -ge 12 ]
then    TIME="afternoon"
else
    TIME="evening"
fi

#System uptime
uptime=`cat /proc/uptime | cut -f1 -d.`
upDays=$((uptime/60/60/24))
upHours=$((uptime/60/60%24))
upMins=$((uptime/60%60))
upSecs=$((uptime%60))

#System load
LOAD1=`cat /proc/loadavg | awk {'print $1'}`
LOAD5=`cat /proc/loadavg | awk {'print $2'}`
LOAD15=`cat /proc/loadavg | awk {'print $3'}`

#Return message
[ -z "$ROOT_PART" ] && ROOT_PART="root partition not available" || ROOT_PART="$ROOT_PART remaining"
[ -z "$HOME_PART" ] && HOME_PART="home partition not available" || HOME_PART="$HOME_PART remaining"
[ -z "$BACKUP_PART" ] && BACKUP_PART="backup partition not available" || BACKUP_PART="$BACKUP_PART remaining"
[ -z "$MNT_PART" ] && MNT_PART="usb partition not available" || MNT_PART="$MNT_PART remaining"

# generate new one:
#   https://patorjk.com/software/taag/#p=display&f=ANSI%20Shadow&t=Rocky%20Linux
echo -e "
\e[92m
██████╗  ██████╗  ██████╗██╗  ██╗██╗   ██╗    ██╗     ██╗███╗   ██╗██╗   ██╗██╗  ██╗
██╔══██╗██╔═══██╗██╔════╝██║ ██╔╝╚██╗ ██╔╝    ██║     ██║████╗  ██║██║   ██║╚██╗██╔╝
██████╔╝██║   ██║██║     █████╔╝  ╚████╔╝     ██║     ██║██╔██╗ ██║██║   ██║ ╚███╔╝
██╔══██╗██║   ██║██║     ██╔═██╗   ╚██╔╝      ██║     ██║██║╚██╗██║██║   ██║ ██╔██╗
██║  ██║╚██████╔╝╚██████╗██║  ██╗   ██║       ███████╗██║██║ ╚████║╚██████╔╝██╔╝ ██╗
╚═╝  ╚═╝ ╚═════╝  ╚═════╝╚═╝  ╚═╝   ╚═╝       ╚══════╝╚═╝╚═╝  ╚═══╝ ╚═════╝ ╚═╝  ╚═╝
\e[0m
Good $TIME $USER"

echo "
===========================================================================
 - Hostname............: $HOSTNAME
 - Release.............: `cat /etc/redhat-release`
 - Users...............: Currently `users | wc -w` user(s) logged on
===========================================================================
 - Current user........: $USER
 - CPU usage...........: $LOAD1, $LOAD5, $LOAD15 (1, 5, 15 min)
 - Memory used.........: $MEMORY1 / $MEMORY2
 - Swap in use.........: `free -m | tail -n 1 | awk '{print $3}'` MB
 - Processes...........: $PSA running
 - System uptime.......: $upDays days $upHours hours $upMins minutes $upSecs seconds
 - Disk space ROOT.....: $ROOT_PART
 - Disk space HOME.....: $HOME_PART
 - Disk space BACK.....: $BACKUP_PART
 - Disk space USB......: $MNT_PART
===========================================================================
"

