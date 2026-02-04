#!/bin/bash

DB_Id=$1
DB_Pass=$2
DB_Name=$3
DB_Table=$4

if [[ -z "$DB_Id" || -z "$DB_Pass" || -z "$DB_Name" || -z "$DB_Table" ]]; then
	echo "Invalid Argument !!!!"
	echo "Usage : $0 <ID> <Pass> <Db_Name> <Table_Name>"
	exit 1
fi

DB_Backup="$HOME/backup/mysql"
Date=$(date +"%Y-%m-%d_%H-%M-%S")

Backup_File="$DB_Backup/${DB_Name}_$Date.sql"

DB_Exists=$(mysql -u "$DB_Id" -p"$DB_Pass" -se "SHOW DATABASES LIKE '$DB_Name';")

if [ -z "$DB_Exists" ]; then
	echo "Error : Database '$DB_Name' doesn't exist"
	exit 1
fi

Table_Exist=$(mysql -u "$DB_Id" -p"$DB_Pass" -se "SHOW TABLES FROM $DB_Name LIKE '$DB_Table'")

if [ -z "$Table_Exist" ]; then
	echo "Error : Table '$DB_Table' doesn't exist in '$DB_Name'"
	exit 1 
fi

mkdir -p "$DB_Backup"
mysqldump -u "$DB_Id" -p"$DB_Pass" "$DB_Name" "$DB_Table" > "$Backup_File" 

if [ $? -eq 0 ]; then
	echo "Backup success : $Backup_File"
else
	echo "Backup failed "
	exit 1
fi

ls -1t "$DB_Backup"/*.sql | tail -n +3 | xargs -r rm -f 


