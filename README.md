# cPanel_backup_issues_tool
A short bash script that helps diagnose backup issues from the cPanel backup logs

Currently this script outputs information with backticks which can be pasted directly as a comment into ticketing systems that support markup and displays

1. The server name
2. The last two cPanel backup logs last two lines which indicate the completion status, or if they are still in progress ........
3. The disk usage of /backup if it has it's own mount point, otherwise the drive partition where the backup directory exists
4. Files that didn't backup due to permissions issues
5. Mysqldump failures as well as the errors related to why they failed, 
6. Over quota accounts
7. A quick overview of the directories and their sizes on /backup as well as current usage for the partition containing /backup


Example of the output:

		host.stagefright.org

		```
		1489219202.log [2017-03-12 10:10:03 -0600] info [backup] Final state is Backup::Success (0)
		[2017-03-12 10:10:04 -0600] info [backup] Sent Backup::Success notification.

		1489305602.log [2017-03-13 12:38:39 -0600] info [backup] Final state is Backup::PartialFailure (TERM)
		[2017-03-13 12:38:39 -0600] info [backup] Sent Backup::PartialFailure notification.

		Filesystem      Size  Used Avail Use% Mounted on
		/dev/sdd1       3.6T  2.7T  811G  77% /backup

		2.7T	/backup/
		1.4T	/backup/2017-03-18
		1.3T	/backup/2017-03-11
		532K	/backup/mysql
		```

		Accounts over quota from the last cPanel backup log:

		```
		stage1
		```

		MySQLdump failures:

		```
		 stp145_structures
		 cesavech_notes
		```

		MySQL dump errors from the cPanel backup log 1489824002.log

		```
		Database does not exist in /var/lib/mysql/cesavech_notes

		stp145_structures[2017-03-19 02:12:49 -0600] stp145_structures: mysqldump: Couldn't execute 'show fields from `v_announce_active_users`': View 'stp145_structures.v_announce_active_users' references invalid table(s) or column(s) or function(s) or definer/invoker of view lack rights to use them (1356)
		[2017-03-19 02:12:49 -0600] stp145_structures: mysqldump: Couldn't execute 'show create table `v_announce_active_users`': View 'tp145_structures.v_announce_active_users' references invalid table(s) or column(s) or function(s) or definer/invoker of view lack rights to use them (1356)
		[2017-03-19 02:12:49 -0600] stp145_structures: mysqldump: Couldn't execute 'show create table `v_announce_active_users`': View 'tp145_structures.v_announce_active_users' references invalid table(s) or column(s) or function(s) or definer/invoker of view lack rights to use them (1356)
		[2017-03-19 02:12:49 -0600] stp145_structures: mysqldump failed -- database may be corrupt
		```

		MySQL user associated with the database still in cPanel?

		```
		"stp145_structures":"192.168.2.1"
		"stp145_structures":"192.168.2.1"
		"stp145_structures":"192.168.2.1"}}}
		"stp145_structures":"stp145"
		```

		Failed due to access permissions issues:

		```
		 /home2/jabaker/.pki
		 /home/jsexton/.git
		 /home/jsexton/public_html/cxx/somerandom_chmodded_script.php
		```
