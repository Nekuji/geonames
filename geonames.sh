#!/bin/bash
#
# The result is a Linux shell script that allows you to download the GeoNames data dumps from
# the official site and create a MySQL database structure in which you can import that dumps.
#
# The script has two different operation modes
#   Downloading the Geonames data dumps
#   Importing the data into a MySQL database

# Default values for database variables.
DB_HOST="localhost"
DB_PORT=3306
DB_NAME="geonames"
DB_USERNAME="root"
DB_PASSWORD="root"

# Default values for folders.
DMP_DIR="dump"
ZIP_DIR="zip"
SQL_DIR="sql"

#######################################
# Downloading the Geonames data dumps
# Globals:
#   DMP_DIR
#   ZIP_DIR
# Arguments:
#   None
# Returns:
#   None
#######################################
download_geonames_data() {
	echo "Downloading GeoNames data (http://www.geonames.org/)..."

	# Create the directory DMP_DIR if not exists
	if [ ! -d "$DMP_DIR" ]; then
		echo "Creating directory [$DMP_DIR]"
		mkdir $DMP_DIR
	fi

	# Create the directory ZIP_DIR if not exists
	if [ ! -d "$ZIP_DIR" ]; then
		echo "Creating directory [$ZIP_DIR]"
		mkdir -p $ZIP_DIR
	fi

	dumps="admin1CodesASCII.txt admin2Codes.txt allCountries.zip alternateNamesV2.zip countryInfo.txt featureCodes_en.txt hierarchy.zip iso-languagecodes.txt timeZones.txt"
	dump_postal_codes="allCountries.zip"

	# Folder DMP_DIR
	for dump in $dumps; do
		echo "Downloading GeoNames data http://download.geonames.org/export/dump/$dump..."
		wget -c -P $DMP_DIR http://download.geonames.org/export/dump/$dump
		if [ ${dump: -4} == ".zip" ]; then
			echo "Unzip [$dump] in [$DMP_DIR]"
			unzip -j "$DMP_DIR/$dump" -d $DMP_DIR
			echo "Deleting [$dump] in [$DMP_DIR]"
			rm "$DMP_DIR/$dump"
		fi
	done

	# Folder ZIP_DIR
	for dump in $dump_postal_codes; do
		echo "Downloading GeoNames data http://download.geonames.org/export/zip/$dump..."
		wget -c -P $ZIP_DIR http://download.geonames.org/export/zip/$dump
		echo "Unzip [$dump] in [$ZIP_DIR]"
		unzip -j "$ZIP_DIR/$dump" -d $ZIP_DIR
		echo "Deleting [$dump] in [$ZIP_DIR]"
		rm "$ZIP_DIR/$dump"
	done
}

#######################################
# Deleting DMP_DIR and ZIP_DIR folders
# Globals:
#   DMP_DIR
#   ZIP_DIR
# Arguments:
#   None
# Returns:
#   None
#######################################
download_geonames_data_delete() {
	echo "Deleting [$DMP_DIR] folders"
	rm -R $DMP_DIR

	echo "Deleting [$ZIP_DIR] folders"
	rm -R $ZIP_DIR
}

#######################################
# Creating $DB_NAME database
# Globals:
#   DB_HOST
#   DB_PORT
#   DB_USERNAME
#   DB_PASSWORD
# Arguments:
#   None
# Returns:
#   None
#######################################
mysql_db_create() {
	echo "Creating database [$DB_NAME]..."
	mysql -h $DB_HOST -P $DB_PORT -u $DB_USERNAME -p$DB_PASSWORD -Bse "DROP DATABASE IF EXISTS $DB_NAME;"
	mysql -h $DB_HOST -P $DB_PORT -u $DB_USERNAME -p$DB_PASSWORD -Bse "CREATE DATABASE $DB_NAME DEFAULT CHARACTER SET utf8;"
	mysql -h $DB_HOST -P $DB_PORT -u $DB_USERNAME -p$DB_PASSWORD -Bse "USE $DB_NAME;"
}

#######################################
# Creating tables for $DB_NAME database
# Globals:
#   DB_HOST
#   DB_PORT
#   DB_USERNAME
#   DB_PASSWORD
#   SQL_DIR
# Arguments:
#   None
# Returns:
#   None
#######################################
mysql_db_tables_create() {
	echo "Creating tables for database [$DB_NAME]..."
	mysql -h $DB_HOST -P $DB_PORT -u $DB_USERNAME -p$DB_PASSWORD -Bse "USE $DB_NAME;"
	mysql -h $DB_HOST -P $DB_PORT -u $DB_USERNAME -p$DB_PASSWORD $DB_NAME <$SQL_DIR/geonames_mysql_db_tables_create.sql
}

#######################################
# Importing geonames dumps into database $DB_NAME
# Globals:
#   DB_HOST
#   DB_PORT
#   DB_USERNAME
#   DB_PASSWORD
#   SQL_DIR
# Arguments:
#   None
# Returns:
#   None
#######################################
mysql_db_import_dumps() {
	echo "Importing GeoNames dumps into database [$DB_NAME]. Please wait a moment..."
	mysql -h $DB_HOST -P $DB_PORT -u $DB_USERNAME -p$DB_PASSWORD --local-infile=1 $DB_NAME <$SQL_DIR/geonames_mysql_db_import_dumps.sql
}

#######################################
# Dropping $DB_NAME database
# Globals:
#   DB_HOST
#   DB_PORT
#   DB_USERNAME
#   DB_PASSWORD
# Arguments:
#   None
# Returns:
#   None
#######################################
mysql_db_drop() {
	echo "Dropping [$DB_NAME] database"
	mysql -h $DB_HOST -P $DB_PORT -u $DB_USERNAME -p$DB_PASSWORD -Bse "DROP DATABASE IF EXISTS $DB_NAME;"
}

#######################################
# Truncating $DB_NAME database
# Globals:
#   DB_HOST
#   DB_PORT
#   DB_USERNAME
#   DB_PASSWORD
#   SQL_DIR
# Arguments:
#   None
# Returns:
#   None
#######################################
mysql_db_truncate() {
	echo "Truncating [$DB_NAME] database"
	mysql -h $DB_HOST -P $DB_PORT -u $DB_USERNAME -p$DB_PASSWORD $DB_NAME <$SQL_DIR/geonames_mysql_db_truncate.sql
}

#######################################
# The command line help
#######################################
display_help() {
	filename=`basename "$0"`
	echo
	echo "This Linux shell script allows you to download the GeoNames data dumps from the official site and create a MySQL database structure in which you can import that dumps."
	echo
	echo "Usage: ./$filename [option] [argument] ..."
	echo "  -a                 : executes an action with the provided argument. Check the action arguments below."
	echo "  -u                 : mysql user for login."
	echo "  -p                 : mysql password for login."
	echo "  -h                 : mysql hostname."
	echo "  -r                 : mysql port."
	echo "  -n                 : mysql database name."
	echo
	echo "Action arguments:"
	echo "  all                : Performs the following actions respectively:"
	echo "                       download-data, db-create, tables-create and db-import"
	echo "  db-create          : Drop the geonames database and create a new one"
	echo "  db-drop            : Drop the geonames database"
	echo "  db-import          : Import GeoNames data dumps into the current database"
	echo "  db-truncate        : Truncate all GeoNames tables from the current database"
	echo "  download-data      : Download the GeoNames data dumps"
	echo "  download-delete    : Delete the folders with the GeoNames data dump"
	echo "  tables-create      : Create the GeoNames tables"
	echo
	echo "If no option is provided to connect to mysql, it will use the default values for database variables:"
	echo "  Host     : localhost"
	echo "  Port     : 3306"
	echo "  Database : geonames"
	echo "  User     : root"
	echo "  Passowrd : root"
	echo
	echo "Example of usage:"
	echo
	echo "  $ ./$filename -a all -u root -p root -h localhost -r 3306 -n geonames"
	echo
}

# Deals with operation mode 2 (Database issues...)
# Parses command line parameters.
if [ "$1" == "--help" ]; then
	display_help
	exit 0
else
	while getopts "a:u:p:h:r:n:" opt; do
		case $opt in
		a) action=$OPTARG ;;
		u) dbusername=$OPTARG ;;
		p) dbpassword=$OPTARG ;;
		h) dbhost=$OPTARG ;;
		r) dbport=$OPTARG ;;
		n) dbname=$OPTARG ;;
		*)
			echo "Invalid option"
			echo "Check the --help section to see the valid command line options"
			exit 1
			;;
		esac
	done
fi

case "$action" in
db-create)
	mysql_db_create
	;;

tables-create)
	mysql_db_tables_create
	;;

download-data)
	download_geonames_data
	;;

download-delete)
	download_geonames_data_delete
	;;

db-import)
	mysql_db_import_dumps
	;;

db-drop)
	mysql_db_drop
	;;

db-truncate)
	mysql_db_truncate
	;;

all)
	download_geonames_data
	mysql_db_create
	mysql_db_tables_create
	mysql_db_import_dumps
	;;

*)
	echo "Invalid action"
	echo "Check the --help section to see the valid command line options"
	exit 1
	;;
esac

if [ $? == 0 ]; then
	echo "[OK]"
else
	echo "[FAILED]"
fi

exit 0
