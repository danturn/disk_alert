ADMIN="dan.turner@cloudhouse.com"
# set alert-level 90 % standard
ALERT=10

meh() {
  local text="The following partitions are low on space:\n"

  while read output
  do
    usep=$(echo $output | awk '{ print $1}' | cut -d'%' -f1  )
    partition=$(echo $output | awk '{ print $2 }' )
    if [ $usep -ge $ALERT ]; then
      text="$text\n$usep""% used on $partition"""
    fi

  done
  echo -e "$text" |
  mail -s "Low Disk alert for \"$(hostname)\"" $ADMIN
}

df -H | grep -vE '^Filesystem|tmpfs|cdrom' | awk '{ print $5 " " $6 }' | meh
