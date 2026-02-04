DB_Id="root"
DB_Pass="Prathmesh@1"
DB_Name="db"
Backup_File="$1"

if [ -z "$Backup_File" ];then
	echo "Usage : $0<backup.sql>"
	exit 1
fi

if [ ! -f "$Backup_File" ];then
	echo "Backup file ${Backup_File} not found"
	exit 1
fi

DB_Exists=$(mysql -u "$DB_Id" -p"$DB_Pass" -se "SHOW DATABASES LIKE '$DB_Name';")

if [ -z "$DB_Exists" ]; then
	mysql -u "$DB_Id" -p"$DB_Pass" -se "CREATE DATABASE $DB_Name"
fi
mysql -u "$DB_Id" -p"$DB_Pass" "$DB_Name" < "$Backup_File"

if [ $? -eq 0 ]; then
	echo "Restore complete succesfully"
else 
	echo "Restore Failed ."
	exit 1
fi
