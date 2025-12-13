## The Problem

There is a requirement to create a Jenkins job to automate the database backup. Below you can find more details to accomplish this task:

Click on the Jenkins button on the top bar to access the Jenkins UI. Login using username admin and password Adm!n321.

1. Create a Jenkins job named database-backup.

2. Configure it to take a database dump of the kodekloud_db01 database present on the Database server in Stratos Datacenter, the database user is kodekloud_roy and password is asdfgdsd.

3. The dump should be named in db_$(date +%F).sql format, where date +%F is the current date.

4. Copy the db_$(date +%F).sql dump to the Backup Server under location /home/clint/db_backups.

5. Further, schedule this job to run periodically at */10 * * * * (please use this exact schedule format).

## The Solution

First of all, I installed the 'publish over SSH' plugin on the Jenkins server and rebooted it. There was an issue because a dependancy didnt install so I instaled that and set it to reboot again.

While it was rebooting, I ran an ```ssh-keygen -t rsa``` on the jumpbox then ```ssh-copy id jenkins@172.16.238.19``` so I could ssh without password authentication if I had too. I then SSH's into the Jenkins server.

On the Jenkins server, I again ran ```ssh-keygen -t rsa``` and then copied that key over to the database and backup servers. This will allow me to transer files over SSH in Jenkins with no authentication issue.

```
ssh-copy-id -i /var/lib/jenkins/.ssh/id_rsa.pub peter@stdb01.stratos.xfusioncorp.com

ssh-copy-id -i /var/lib/jenkins/.ssh/id_rsa.pub clint@stbkp01.stratos.xfusioncorp.com
```
Once the keys were shared and the Jenkins server came back on, I conected and added the 2 servers and SSH servers in 'Manage Jenkins' > 'System' and tested the conection on both to ensure it worked.

Once that was done, I added the new job and set the build trigger to run periodically with the crontab schedule ```*/10 * * * * ```

In the build section I set it to "Execute Shell" and added this bash script:

```
#!/bin/bash

# --- Database Details ---
DB_NAME="kodekloud_db01"
DB_USER="kodekloud_roy"
DB_PASS="asdfgdsd"
DB_HOST="stdb01.stratos.xfusioncorp.com"
DB_USER_SSH="peter" 

# --- Backup Details ---
BACKUP_HOST="stbkp01.stratos.xfusioncorp.com"
BACKUP_USER="clint"
BACKUP_DIR="/home/clint/db_backups"

# --- File Naming ---
DATE_FORMAT=$(date +%F)
DUMP_FILE="db_${DATE_FORMAT}.sql"

# 1. Execute DUMP REMOTELY on the DB Server and PIPE output to the Jenkins Server
echo "Executing remote database dump on ${DB_HOST} and piping output..."
ssh -T "${DB_USER_SSH}"@"${DB_HOST}" "mysqldump -u ${DB_USER} -p${DB_PASS} ${DB_NAME}" > "${DUMP_FILE}"

if [ $? -ne 0 ]; then
    echo "ERROR: Remote database dump failed. Check SSH key setup or DB credentials."
    rm -f "${DUMP_FILE}"
    exit 1
fi

echo "Database dump successful and saved locally: ${DUMP_FILE}"

# 2. Copy the dump file from the Jenkins Server to the Backup Server
echo "Copying ${DUMP_FILE} to Backup Server (${BACKUP_HOST})..."
scp "${DUMP_FILE}" "${BACKUP_USER}"@"${BACKUP_HOST}":"${BACKUP_DIR}/"

if [ $? -eq 0 ]; then
    echo "File successfully copied to ${BACKUP_HOST}:${BACKUP_DIR}/${DUMP_FILE}"
    # Clean up the local dump file
    rm "${DUMP_FILE}"
else
    echo "ERROR: Failed to copy the dump file via SCP."
    exit 1
fi
```

I ran the job and got the following output.
<img width="1222" height="405" alt="Screenshot 2025-12-13 at 17 35 43" src="https://github.com/user-attachments/assets/819adc3c-7b02-4904-a661-bb42f0817c73" />

## Thoughts and Takeaways
That task felt somewhat similar to yesterdays, the key difference was the need for a bash script which fyi, I did not write for this task. I'm a little under the weather and as is my 2 year old and my wife so I'm a little bit slower and not quite with it today. I will however, look to re-create this in my home lab and write the script myself as thats ultimately the goal right? Time for tea. 
