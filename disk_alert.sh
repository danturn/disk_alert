#!/bin/bash
USAGE_THRESHOLD=90

check_disk() {
  local text="The following partitions are low on space:\n"
  local alerts_to_send=false
  while read output
  do
    usage=$(echo $output | awk '{ print $1}' | cut -d'%' -f1  )
    partition=$(echo $output | awk '{ print $2 }' )
    if [ $usage -ge $USAGE_THRESHOLD ]; then
      text="$text\n$usage""% used on $partition"""
      alerts_to_send=true
    fi
  done

  if [ $alerts_to_send == true ]
    then 
      echo -e "$text" |
      mail -s "Low Disk alert for \"$(hostname)\"" $ADMIN_EMAIL
  fi
}

: "${ADMIN_EMAIL?Need to set the ADMIN_EMAIL environment variable}"
df -H | grep -vE '^Filesystem|tmpfs|cdrom' | awk '{ print $5 " " $6 }' | check_disk
