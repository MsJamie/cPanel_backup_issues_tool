#!/bin/bash

# Written by Jsexton
# Refactored by Mcunningham

div(){ echo '```'; }
latest=$(ls -rt1 /usr/local/cpanel/logs/cpbackup/*.log | tail -1);

echo -en "\e]0;$USER@$HOSTNAME\a"; ## Set icon name and window name to user@hostname
echo; hostname; echo; div; ## Outputs the hostname, great for checking lots of servers

## Checks the cPanel backup logs for partial backup failures
for backup in /usr/local/cpanel/logs/cpbackup/*.log; do
  echo -e "\n$backup"; tail -2 $backup | sed 's/^/  /g';
done | tail -7 ; echo;

## Report the current usage on the backup drive as well as the backups on the partition
df -h /backup; echo; du -h --max=3 /backup/ | egrep -v "accounts|system|lost" | sort -rh;
div;

## Check for accounts over quota from the cPanel backup log
echo -e "\nAccounts over quota from the last cPanel backup log:\n"; div;
grep quota $latest | cut -d '“' -f2-3 | cut -d '/' -f3\
 | egrep -v "failed to write|--skipquota" | sort | uniq;
div

## Check for MySQLdump failures from the cPanel backup log
echo -e "\nMySQLdump failures:\n"; div;
grep "mysqldump failed" $latest
for database in $(grep "mysqldump failed" $latest | cut -d '“' -f2-3 | cut -d "]" -f2- | cut -d ':' -f1); do
  if [[ -d /var/lib/mysql/$database ]]; then
    echo -e "\nMySQL dump errors from the cPanel backup log $latest";
    grep $database $latest | grep mysqldump
  else
    echo -ne "\nDatabase does not exist in /var/lib/mysql/$database\n";
  fi;

  ## Check for MySQL databases that don't exist anymore but are still have cPanel account associations
  echo -e "\nMySQL user associated with the database still in cPanel?\n";
  sed 's/,/\n/g' /var/cpanel/databases/*.json | grep $database ;
done; div;

## Check for accounts that the backups failed due to file or directory permissions issues
echo -e "\nFailed due to access permissions issues:\n"; div;
grep "Permission denied" $latest | cut -d '“' -f2-3 | cut -d "]" -f2- | cut -d ':' -f1
div; echo
